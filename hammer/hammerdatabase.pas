unit HammerDatabase;

interface
type
	THammerDatabaseEntry = record
		ProjectID : Integer;
		Title : String;
		Description : String;
		Instructions : String;
		AuthorID : Integer;
		AuthorName : String;
		Timestamp : String;
	end;
	THammerDatabaseEntryArray = Array of THammerDatabaseEntry;

procedure HammerDatabaseConnect(HostName : String; Port : String);
function HammerDatabaseQuery(Query : String) : THammerDatabaseEntryArray;

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

function HammerDatabaseQuery(Query : String) : THammerDatabaseEntryArray;
var
	Client : TFPHTTPClient;
	JStr : String;
	JData, JItem : TJSONData;
	JObj : TJSONObject;
	JArr : TJSONArray;
	Q : String;
	I : Integer;
begin
	HammerDatabaseQuery := [];

	JData := GetJSON('{}');
	JObj := JData as TJSONObject;

	Q := 'title:"' + Escape(Query) + '" instructions:"' + Escape(Query) + '" description:"' + Escape(Query) + '" author_search_name:"' + Escape(Query) + '"';

	JObj.Add('query', Q);
	JObj.Add('limit', 20);

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
		SetLength(HammerDatabaseQuery, JArr.Count);

		for I := 0 to JArr.Count - 1 do
		begin
			JObj := JArr.Items[I] as TJSONObject;

			HammerDatabaseQuery[I].ProjectID := JObj.FindPath('project_id').AsInteger;
			HammerDatabaseQuery[I].Title := JObj.FindPath('title').AsString;

			JItem := JObj.FindPath('description');
			if Assigned(JItem) then HammerDatabaseQuery[I].Description := JItem.AsString;

			JItem := JObj.FindPath('instructions');
			if Assigned(JItem) then HammerDatabaseQuery[I].Instructions := JItem.AsString;

			JItem := JObj.FindPath('author_id');
			if Assigned(JItem) then HammerDatabaseQuery[I].AuthorID := JItem.AsInteger;

			JItem := JObj.FindPath('author_name');
			if Assigned(JItem) then HammerDatabaseQuery[I].AuthorName := JItem.AsString;

			JItem := JObj.FindPath('timestamp');
			if Assigned(JItem) then HammerDatabaseQuery[I].Timestamp := JItem.AsString;
		end;
	end;

	JData.Free();
end;

end.
