program crawl;

uses
	CrawlProject,
	CrawlUser;

var
	I : Integer;
begin
	I := 1;
	while I < ParamCount do
	begin
		if ParamStr(I) = '--user' then
		begin
			I := I + 1;
			CrawlUserGet(ParamStr(I));
		end
		else
		begin
			CrawlProjectGet(ParamStr(I));
		end;
	end;
end.
