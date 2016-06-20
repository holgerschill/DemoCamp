/*
 * generated by Xtext 2.10.0
 */
package org.xtext.example.mydsl.web

import com.google.inject.Provider
import java.io.File
import java.io.IOException
import java.util.List
import java.util.concurrent.ExecutorService
import java.util.concurrent.Executors
import java.util.jar.JarFile
import java.util.jar.Manifest
import java.util.zip.ZipException
import javax.servlet.annotation.WebServlet
import org.eclipse.emf.common.util.URI
import org.eclipse.emf.ecore.plugin.EcorePlugin
import org.eclipse.emf.ecore.resource.ResourceSet
import org.eclipse.xtext.mwe.NameBasedFilter
import org.eclipse.xtext.mwe.PathTraverser
import org.eclipse.xtext.resource.IResourceDescription
import org.eclipse.xtext.resource.XtextResourceSet
import org.eclipse.xtext.web.server.persistence.ResourceBaseProviderImpl
import org.eclipse.xtext.web.servlet.XtextServlet
import org.eclipse.xtext.resource.impl.ResourceDescriptionsData

/**
 * Deploy this class into a servlet container to enable DSL-specific services.
 */
@WebServlet(name = 'XtextServices', urlPatterns = '/xtext-service/*')
class MyDslServlet extends XtextServlet {
	
	val List<ExecutorService> executorServices = newArrayList
	String base = '/Users/schill/Documents/Conferences/Democamp/Zuerich2016/DemoCamp/org.xtext.example.mydsl.web/files'
//	String base = './files'
	override init() {
		super.init()
		val Provider<ExecutorService> executorServiceProvider = [Executors.newCachedThreadPool => [executorServices += it]]
		val resourceBaseProvider = new ResourceBaseProviderImpl(base)
		val index = new ResourceDescriptionsData(newArrayList())
		val injector = new MyDslWebSetup(executorServiceProvider,resourceBaseProvider, index).createInjectorAndDoEMFRegistration()
		
		val rs = new XtextResourceSet
		val fileURIs = collectResources(newArrayList(base), rs)
		val manager = injector.getInstance(IResourceDescription.Manager)
		for(URI uri : fileURIs){
			val resource = rs.getResource(uri,true)
			val desc = manager.getResourceDescription(resource)
			index.addDescription(uri,desc)
		}
	}
	
	override destroy() {
		executorServices.forEach[shutdown()]
		executorServices.clear()
		super.destroy()
	}
	
	def protected List<URI> collectResources(Iterable<String> roots, ResourceSet resourceSet) {
		val extensions = "mydsl"
		val nameBasedFilter = new NameBasedFilter
		nameBasedFilter.setRegularExpression(".*\\.(?:(" + extensions + "))$");
		val List<URI> resources = newArrayList();

		val modelsFound = new PathTraverser().resolvePathes(
			roots.toList,
			[ input |
				val matches = nameBasedFilter.matches(input)
				if (matches) {
					
					resources.add(input);
				}
				return matches
			]
		)
		modelsFound.asMap.forEach [ uri, resource |
			val file = new File(uri)
			if (resource != null && !file.directory && file.name.endsWith(".jar")) {
				registerBundle(file)
			}
		]
		return resources;
	}
	
	def protected registerBundle(File file) {
		var JarFile jarFile = null;
		try {
			jarFile = new JarFile(file);
			val Manifest manifest = jarFile.getManifest();
			if (manifest == null)
				return;
			var String name = manifest.getMainAttributes().getValue("Bundle-SymbolicName");
			if (name != null) {
				val int indexOf = name.indexOf(';');
				if (indexOf > 0)
					name = name.substring(0, indexOf);
				if (EcorePlugin.getPlatformResourceMap().containsKey(name))
					return;
				val String path = "archive:" + file.toURI() + "!/";
				val URI uri = URI.createURI(path);
				EcorePlugin.getPlatformResourceMap().put(name, uri);
			}
		} catch (ZipException e) {
			
		} catch (Exception e) {
			
		} finally {
			try {
				if (jarFile != null)
					jarFile.close();
			} catch (IOException e) {
				
			}
		}
	}
}
