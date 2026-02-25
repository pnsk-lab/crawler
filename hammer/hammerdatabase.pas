unit HammerDatabase;

interface
type
	THammerDatabaseEntry = record
		NumFound : Integer;
		ProjectID : Integer;
		Title : String;
		Description : String;
		Instructions : String;
		AuthorID : Integer;
		AuthorName : String;
		Timestamp : String;
	end;
	THammerDatabaseEntryArray = Array of THammerDatabaseEntry;

const
	HammerDatabaseMaxQuery : Integer = 20;

procedure HammerDatabaseConnect(HostName : String; Port : String);
function HammerDatabaseQuery(Query : String; Offset : Integer = 0; Project : Integer = -1) : THammerDatabaseEntryArray;

implementation
uses
	fphttpclient,
	opensslsockets,
	fpjson,
	jsonparser,
	classes,
	sysutils;

var
	DBHostName : String;
	DBPort : String;

procedure HammerDatabaseConnect(HostName : String; Port : String);
begin
	DBHostName := HostName;
	DBPort := Port;
end;

function Escape(Query : String) : String;
begin
	Escape := Query;
	Escape := StringReplace(Escape, '\', '\\', [rfReplaceAll]);
	Escape := StringReplace(Escape, '"', '\"', [rfReplaceAll]);
end;

function HammerDatabaseQuery(Query : String; Offset : Integer = 0; Project : Integer = -1) : THammerDatabaseEntryArray;
var
	Client : TFPHTTPClient;
	JStr : String;
	JData, JItem, TNumFound : TJSONData;
	JObj : TJSONObject;
	JArr : TJSONArray;
	Q : String;
	I : Integer;
begin
	HammerDatabaseQuery := [];

	JData := GetJSON('{}');
	JObj := JData as TJSONObject;

	if Project = -1 then
	begin
		Q := 'title:"' + Escape(Query) + '" instructions:"' + Escape(Query) + '" description:"' + Escape(Query) + '" author_search_name:"' + Escape(Query) + '"';
	end
	else
	begin
		Q := 'project_id:' + IntToStr(Project);
	end;

	JObj.Add('query', Q);
	JObj.Add('limit', HammerDatabaseMaxQuery);
	JObj.Add('offset', Offset);
	JObj.Add('sort', 'timestamp desc');

	while true do
	begin
		Client := TFPHTTPClient.Create(nil);
		try
			Client.AddHeader('Content-Type', 'application/json');
			Client.RequestBody := TRawByteStringStream.Create(JData.AsJSON);
			JStr := Client.Post('http://' + DBHostName + ':' + DBPort + '/solr/toolbox/query');
		except
			Client.Free();
			continue;
		end;
		Client.Free();
		break;
	end;

	JData.Free();

	JData := GetJSON(JStr, false);
	JObj := JData as TJSONObject;

	JArr := JObj.FindPath('response.docs') as TJSONArray;
	if Assigned(JArr) then
	begin
		TNumFound := JObj.FindPath('response.numFound');

		SetLength(HammerDatabaseQuery, JArr.Count);

		for I := 0 to JArr.Count - 1 do
		begin
			JObj := JArr.Items[I] as TJSONObject;

			if Assigned(TNumFound) then HammerDatabaseQuery[I].NumFound := TNumFound.AsInteger;

			HammerDatabaseQuery[I].ProjectID := JObj.FindPath('project_id').AsInteger;

			JItem := JObj.FindPath('title');
			HammerDatabaseQuery[I].Title := '';
			if Assigned(JItem) then HammerDatabaseQuery[I].Title := JObj.FindPath('title').AsString;

			JItem := JObj.FindPath('description');
			HammerDatabaseQuery[I].Description := '';
			if Assigned(JItem) then HammerDatabaseQuery[I].Description := JItem.AsString;

			JItem := JObj.FindPath('instructions');
			HammerDatabaseQuery[I].Instructions := '';
			if Assigned(JItem) then HammerDatabaseQuery[I].Instructions := JItem.AsString;

			JItem := JObj.FindPath('author_id');
			HammerDatabaseQuery[I].AuthorID := 0;
			if Assigned(JItem) then HammerDatabaseQuery[I].AuthorID := JItem.AsInteger;

			JItem := JObj.FindPath('author_name');
			HammerDatabaseQuery[I].AuthorName := '';
			if Assigned(JItem) then HammerDatabaseQuery[I].AuthorName := JItem.AsString;

			JItem := JObj.FindPath('timestamp');
			HammerDatabaseQuery[I].Timestamp := '';
			if Assigned(JItem) then HammerDatabaseQuery[I].Timestamp := JItem.AsString;
		end;
	end;

	JData.Free();
end;

end.
