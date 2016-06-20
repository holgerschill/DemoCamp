package org.xtext.example.mydsl.web.resources

import com.google.inject.Inject
import com.google.inject.Provider
import java.io.IOException
import org.eclipse.emf.ecore.resource.ResourceSet
import org.eclipse.xtext.resource.IResourceDescription
import org.eclipse.xtext.resource.impl.ResourceDescriptionsData
import org.eclipse.xtext.web.server.IServiceContext
import org.eclipse.xtext.web.server.model.IWebResourceSetProvider
import org.eclipse.xtext.web.server.model.IXtextWebDocument
import org.eclipse.xtext.web.server.persistence.FileResourceHandler
import org.eclipse.xtext.web.server.persistence.IResourceBaseProvider

class IndexBuildingFileResourceHandler extends FileResourceHandler {
	@Inject IResourceBaseProvider resourceBaseProvider
	@Inject IResourceDescription.Manager manager
	@Inject	IWebResourceSetProvider rsProvider;
	
	
	override get(String resourceId, IServiceContext serviceContext) throws IOException {
		super.get(resourceId, serviceContext)
		
	}
	
	override put(IXtextWebDocument document, IServiceContext serviceContext) throws IOException {
		super.put(document,serviceContext)
		val uri = resourceBaseProvider.getFileURI(document.resourceId)
		val rs = rsProvider.get("dummy",serviceContext)
		val index = ResourceDescriptionsData.ResourceSetAdapter.findResourceDescriptionsData(rs) 
		if(index.getResourceDescription(uri) != null)
			index.removeDescription(uri)
		val resource = rs.getResource(uri,true)
		val desc = manager.getResourceDescription(resource)
		index.addDescription(uri,desc)
		println("Indexed " + uri.toString)
	}	
}