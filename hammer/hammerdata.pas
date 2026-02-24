unit HammerData;

interface
uses
	httpdefs;

procedure HammerDataAssetsRoute(Req : TRequest; Res : TResponse);
procedure HammerDataProjectsRoute(Req : TRequest; Res : TResponse);

implementation
uses
	classes,
	sysutils,
	httpprotocol,
	HammerExtension,
	HammerInfo,
	HammerUtility;

procedure HammerDataAssetsRoute(Req : TRequest; Res : TResponse);
begin
	HammerUtilityHeader(Res, HammerInfoDirectory + 'assets/' + Req.RouteParams['file']);
	Res.ContentType := HammerExtensionGet(Req.RouteParams['file']);
	Res.ContentStream := TFileStream.Create(HammerInfoDirectory + 'assets/' + Req.RouteParams['file'], fmOpenRead or fmShareDenyWrite);
end;

procedure HammerDataProjectsRoute(Req : TRequest; Res : TResponse);
begin
	HammerUtilityHeader(Res, HammerInfoDirectory + 'projects/' + Req.RouteParams['id'] + '/' + Req.RouteParams['timestamp'] + '/' + Req.RouteParams['file']);
	Res.ContentType := HammerExtensionGet(Req.RouteParams['file']);
	Res.ContentStream := TFileStream.Create(HammerInfoDirectory + 'projects/' + Req.RouteParams['id'] + '/' + Req.RouteParams['timestamp'] + '/' + Req.RouteParams['file'], fmOpenRead or fmShareDenyWrite);
end;

end.
