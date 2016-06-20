package org.xtext.example.mydsl.web.resources;

import com.google.inject.Inject;
import com.google.inject.Provider;
import org.eclipse.emf.ecore.resource.ResourceSet;
import org.eclipse.xtext.resource.impl.ResourceDescriptionsData;
import org.eclipse.xtext.web.server.IServiceContext;
import org.eclipse.xtext.web.server.model.IWebResourceSetProvider;

@SuppressWarnings("all")
public class WebResourceSetProvider implements IWebResourceSetProvider {
  @Inject
  private Provider<ResourceSet> provider;
  
  @Inject
  private ResourceDescriptionsData index;
  
  public static String RSIDENTIFIER = "ResourceSet";
  
  @Override
  public ResourceSet get(final String resourceId, final IServiceContext serviceContext) {
    final ResourceSet rs = this.provider.get();
    ResourceDescriptionsData.ResourceSetAdapter.installResourceDescriptionsData(rs, this.index);
    return rs;
  }
}
