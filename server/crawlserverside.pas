unit CrawlServerSide;

interface
uses
	httpdefs;

procedure CrawlServerSideProcess(Res : TResponse; FileName : String);

implementation
uses
	sysutils,
	classes,
	strutils;

procedure CrawlServerSideProcess(Res : TResponse; FileName : String);
var
	TF : TextFile;
	Lines : Array of String;
	LineStr : String;
	I : Integer;
begin
	AssignFile(TF, FileName);

	try Reset(TF);
	except
		on E : EInOutError do
		begin
			E.Message := 'Unable to open file "' + FileName + '": ' + E.Message;
			raise;
		end;
		on E : Exception do
		begin
			raise;
		end;
	end;

	Res.Content := '';
	SetLength(Lines, 0);
	repeat
		ReadLn(TF, LineStr);

		Insert(LineStr, Lines, Length(Lines));
	until EOF(TF);

	for I := 0 to Length(Lines) - 1 do
	begin
		if StartsText('<!--#', Trim(Lines[I])) then
		begin

		end
		else
		begin
			Res.Content := Res.Content + Lines[I] + #13#10;
		end;
	end;

	CloseFile(TF);
end;

end.
