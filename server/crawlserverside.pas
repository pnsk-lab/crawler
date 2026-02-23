unit CrawlServerSide;

interface
uses
	httpdefs;

procedure CrawlServerSideProcess(Res : TResponse; FileName : String);

implementation
uses
	sysutils,
	classes;

procedure CrawlServerSideProcess(Res : TResponse; FileName : String);
var
	TF : TextFile;
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

	CloseFile(TF);
end;

end.
