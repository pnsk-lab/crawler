unit CrawlUser;

interface
procedure CrawlUserGet(UserName : String);

implementation
uses
	CrawlProject,
	fphttpclient,
	opensslsockets,
	fpjson,
	jsonparser,
	sysutils;

procedure CrawlUserGet(UserName : String);
var
	JStr : String;
	JData, JItem : TJSONData;
	N : Integer;
	I : Integer;
begin
	N := 0;

	while true do
	begin
		JStr := TFPHttpClient.SimpleGet('https://api.scratch.mit.edu/users/' + UserName + '/projects?limits=20&offset=' + IntToStr(N));
		JData := GetJSON(JStr);

		if JData.Count = 0 then
		begin
			JData.Free();
			break;
		end;

		for I := 0 to JData.Count - 1 do
		begin
			JItem := JData.Items[I];

			CrawlProjectGet(JItem.FindPath('id').AsString);
		end;

		JData.Free();

		N := N + 20;
	end;
end;

end.
