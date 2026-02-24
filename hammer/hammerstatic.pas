unit HammerStatic;

interface
uses
	httpdefs;

procedure HammerStaticRoute(Req : TRequest; Res : TResponse);

implementation
uses
	classes,
	sysutils,
	HammerExtension,
	HammerUtility;

procedure HammerStaticRoute(Req : TRequest; Res : TResponse);
begin
	HammerUtilityHeader(Res, 'static/' + Req.RouteParams['file']);
	Res.ContentType := HammerExtensionGet(Req.RouteParams['file']);
	Res.ContentStream := TFileStream.Create('static/' + Req.RouteParams['file'], fmOpenRead or fmShareDenyWrite);
end;

end.
