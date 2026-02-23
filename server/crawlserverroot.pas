unit CrawlServerRoot;

interface
uses
	httpdefs;

procedure CrawlServerRootRoute(Req : TRequest; Res : TResponse);

implementation
uses
	CrawlServerSide,
	CrawlServerExtension;

procedure CrawlServerRootRoute(Req : TRequest; Res : TResponse);
var
	Path : String;
begin
	Path := 'dynamic' + Req.PathInfo + '/index.html';

	Res.ContentType := CrawlServerExtensionGet(Path);
	CrawlServerSideProcess(Res, Path);
end;

end.
