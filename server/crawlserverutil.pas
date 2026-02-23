unit CrawlServerUtil;

interface
uses
	httpdefs;

procedure CrawlServerUtilHeader(Res : TResponse; Path : String);

implementation
uses
	sysutils,
	httpprotocol;

procedure CrawlServerUtilHeader(Res : TResponse; Path : String);
var
	DT : TDateTime;
	Time : LongInt;
begin
	Time := FileAge(Path);

	DT := FileDateToDateTime(Time);

	Res.SetHeader(hhLastModified, FormatDateTime('ddd, d mmm yyyy hh:nn:ss', DT) + ' GMT');
end;

end.
