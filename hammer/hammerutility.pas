unit HammerUtility;

interface
uses
	httpdefs,
	fgl;

type
	THammerStringMap = specialize TFPGMap<String, String>;
	THammerStringArray = Array of String;

procedure HammerUtilityHeader(Res : TResponse; Path : String);
function HammerUtilityParseQuery(Query : String) : THammerStringMap;

implementation
uses
	sysutils,
	httpprotocol;

procedure HammerUtilityHeader(Res : TResponse; Path : String);
var
	DT : TDateTime;
	Time : LongInt;
begin
	Time := FileAge(Path);

	DT := FileDateToDateTime(Time);

	Res.SetHeader(hhLastModified, FormatDateTime('ddd, d mmm yyyy hh:nn:ss', DT) + ' GMT');
end;

function HammerUtilityParseQuery(Query : String) : THammerStringMap;
var
	I : Integer;
	K : String;
	V : String;
	S : Integer;
begin
	HammerUtilityParseQuery := THammerStringMap.Create();

	K := '';
	V := '';
	S := 0;
	for I := 1 to Length(Query) do
	begin
		if (S = 0) and (Copy(Query, I, 1) = '=') then
		begin
			S := 1;
		end
		else if (S = 1) and (Copy(Query, I, 1) = '&') then
		begin
			S := 0;

			HammerUtilityParseQuery[HTTPDecode(K)] := HTTPDecode(V);
			K := '';
			V := '';
		end
		else if S = 0 then
		begin
			K := K + Copy(Query, I, 1);
		end
		else if S = 1 then
		begin
			V := V + Copy(Query, I, 1);
		end;
	end;

	if Length(K) > 0 then
	begin
		HammerUtilityParseQuery[HTTPDecode(K)] := HTTPDecode(V);
	end;
end;

end.
