unit CrawlProject;

interface
procedure CrawlProjectGet(ID : String; Token: String);
procedure CrawlProjectGet(ID : String);

implementation
uses
	fphttpclient,
	opensslsockets,
	fpjson,
	jsonparser,
	sysutils;

procedure CrawlProjectGet(ID : String; Token: String);
var
	JStr : String;
	JData : TJSONData;
	JObj : TJSONObject;
	ProjectJSON : TextFile;
begin
	JStr := TFPHttpClient.SimpleGet('https://projects.scratch.mit.edu/' + ID + '?token=' + Token);
	JData := GetJSON(JStr);
	JObj := JData as TJSONObject;

	WriteLn('Got project.json for ' + ID);

	CreateDir(ID);

	AssignFile(ProjectJSON, ID + '/project.json');
	Rewrite(ProjectJSON);
	Write(ProjectJSON, JStr);
	CloseFile(ProjectJSON);
	
	JData.Free();
end;

procedure CrawlProjectGet(ID : String);
var
	JData, JToken : TJSONData;
	JObj : TJSONObject;
	JStr : String;
	MetaJSON : TextFile;
begin
	JStr := TFPHttpClient.SimpleGet('https://api.scratch.mit.edu/projects/' + ID);
	JData := GetJSON(JStr);
	JObj := JData as TJSONObject;

	JToken := JObj.FindPath('project_token');
	if Assigned(JToken) then
	begin
		CreateDir(ID);

		AssignFile(MetaJSON, ID + '/meta.json');
		Rewrite(MetaJSON);
		Write(MetaJSON, JStr);
		CloseFile(MetaJSON);

		WriteLn('Got projcet token for ' + ID);
		CrawlProjectGet(ID, JToken.AsString);
	end;
	
	JData.Free();
end;

end.
