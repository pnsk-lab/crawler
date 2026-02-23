program crawl;

uses
	CrawlProject;

var
	I : Integer;
begin
	for I := 1 to ParamCount do
	begin
		CrawlProjectGet(ParamStr(I));
	end;
end.
