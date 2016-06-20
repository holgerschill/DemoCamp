package org.xtext.example.mydsl.web.resources

import com.google.inject.Inject
import com.google.inject.Provider
import org.eclipse.emf.ecore.resource.ResourceSet
import org.eclipse.xtext.resource.impl.ResourceDescriptionsData
import org.eclipse.xtext.web.server.IServiceContext
import org.eclipse.xtext.web.server.model.IWebResourceSetProvider

class WebResourceSetProvider implements IWebResourceSetProvider {
	@Inject Provider<ResourceSet> provider
	@Inject ResourceDescriptionsData index
	public static String RSIDENTIFIER = "ResourceSet"
	
	override ResourceSet get(String resourceId, IServiceContext serviceContext) {
		val rs = provider.get
		ResourceDescriptionsData.ResourceSetAdapter.installResourceDescriptionsData(rs,index)
		return rs
	}
}
