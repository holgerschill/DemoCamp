package org.xtext.example.mydsl.web.resources;

import com.google.common.base.Objects;
import com.google.inject.Inject;
import java.io.IOException;
import org.eclipse.emf.common.util.URI;
import org.eclipse.emf.ecore.resource.Resource;
import org.eclipse.emf.ecore.resource.ResourceSet;
import org.eclipse.xtext.resource.IResourceDescription;
import org.eclipse.xtext.resource.impl.ResourceDescriptionsData;
import org.eclipse.xtext.web.server.IServiceContext;
import org.eclipse.xtext.web.server.model.IWebResourceSetProvider;
import org.eclipse.xtext.web.server.model.IXtextWebDocument;
import org.eclipse.xtext.web.server.model.XtextWebDocument;
import org.eclipse.xtext.web.server.persistence.FileResourceHandler;
import org.eclipse.xtext.web.server.persistence.IResourceBaseProvider;

@SuppressWarnings("all")
public class IndexBuildingFileResourceHandler extends FileResourceHandler {
  @Inject
  private IResourceBaseProvider resourceBaseProvider;
  
  @Inject
  private IResourceDescription.Manager manager;
  
  @Inject
  private IWebResourceSetProvider rsProvider;
  
  @Override
  public XtextWebDocument get(final String resourceId, final IServiceContext serviceContext) throws IOException {
    return super.get(resourceId, serviceContext);
  }
  
  @Override
  public void put(final IXtextWebDocument document, final IServiceContext serviceContext) throws IOException {
    super.put(document, serviceContext);
    String _resourceId = document.getResourceId();
    final URI uri = this.resourceBaseProvider.getFileURI(_resourceId);
    final ResourceSet rs = this.rsProvider.get("", serviceContext);
    final ResourceDescriptionsData index = ResourceDescriptionsData.ResourceSetAdapter.findResourceDescriptionsData(rs);
    IResourceDescription _resourceDescription = index.getResourceDescription(uri);
    boolean _notEquals = (!Objects.equal(_resourceDescription, null));
    if (_notEquals) {
      index.removeDescription(uri);
    }
    final Resource resource = rs.getResource(uri, true);
    final IResourceDescription desc = this.manager.getResourceDescription(resource);
    index.addDescription(uri, desc);
  }
}
