unit CrawlServerData;

interface
uses
	httpdefs;

procedure CrawlServerDataAssetsRoute(Req : TRequest; Res : TResponse);
procedure CrawlServerDataProjectsRoute(Req : TRequest; Res : TResponse);

implementation
uses
	classes,
	sysutils,
	CrawlServerExtension,
	CrawlServerInfo;

procedure CrawlServerDataAssetsRoute(Req : TRequest; Res : TResponse);
begin
	Res.ContentType := CrawlServerExtensionGet(Req.RouteParams['file']);
	Res.ContentStream := TFileStream.Create(CrawlServerInfoDirectory + 'assets/' + Req.RouteParams['file'], fmOpenRead or fmShareDenyWrite);
end;

procedure CrawlServerDataProjectsRoute(Req : TRequest; Res : TResponse);
begin
	Res.ContentType := CrawlServerExtensionGet(Req.RouteParams['file']);
	Res.ContentStream := TFileStream.Create(CrawlServerInfoDirectory + 'projects/' + Req.RouteParams['id'] + '/' + Req.RouteParams['timestamp'] + '/' + Req.RouteParams['file'], fmOpenRead or fmShareDenyWrite);
end;

end.
