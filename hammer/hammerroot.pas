unit HammerRoot;

interface
uses
	httpdefs;

procedure HammerRootRoute(Req : TRequest; Res : TResponse);

implementation
uses
	HammerSide,
	HammerExtension;

procedure HammerRootRoute(Req : TRequest; Res : TResponse);
var
	Path : String;
begin
	Path := 'dynamic/index.html';

	Res.ContentType := HammerExtensionGet(Path);
	Res.Content := HammerSideProcess(Req, Res, Path);
end;

end.
