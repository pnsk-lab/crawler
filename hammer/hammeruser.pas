unit HammerUser;

interface
uses
	httpdefs,
	HammerUtility,
	HammerInfo;

procedure HammerUserProcess(Vars : THammerStringMap; Query : THammerStringMap; Req : TRequest; Res : TResponse);

implementation
uses
	HammerDatabase;

procedure HammerUserProcess(Vars : THammerStringMap; Query : THammerStringMap; Req : TRequest; Res : TResponse);
begin
end;

end.
