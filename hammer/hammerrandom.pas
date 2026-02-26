unit HammerRandom;

interface
uses
	httpdefs,
	HammerUtility,
	HammerInfo;

procedure HammerRandomProcess(Vars : THammerStringMap; Query : THammerStringMap; Req : TRequest; Res : TResponse);

implementation
uses
	HammerDatabase,
	sysutils;

procedure HammerRandomProcess(Vars : THammerStringMap; Query : THammerStringMap; Req : TRequest; Res : TResponse);
var
	Arr : THammerDatabaseEntryArray;
begin
	Arr := HammerDatabaseQueryRandom();
	if Length(Arr) > 0 then
	begin
		Vars['STATUS_CODE'] := '307';
		Vars['STATUS_TEXT'] := 'Temporary Redirect';
		Res.Location := '/project?p=' + IntToStr(Arr[0].ProjectID);
	end;
end;

end.
