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
begin
	Res.ContentType := CrawlServerExtensionGet('dynamic/index.html');
	CrawlServerSideProcess(Res, 'dynamic/index.html');
end;

end.
