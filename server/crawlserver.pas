program crawlserver;

uses
	{$ifdef unix}
	cthreads,
	baseunix,
	{$endif}
	fphttpapp,
	httproute,
	httpdefs,
	sysutils,
	dos,
	eventlog,
	CrawlServerRoot,
	CrawlServerData,
	CrawlServerStatic,
	CrawlServerInfo;

procedure OnShowRequestException(Res : TResponse; AnException : Exception; var handled : Boolean);
begin
	Res.ContentType := 'text/html';
	if (AnException.ClassName = 'EFOpenError') or (AnException.ClassName = 'EInOutError') then
	begin
		Res.Code := 404;
		Res.CodeText := 'Not Found';
	end
	else
	begin
		Res.Code := 500;
		Res.CodeText := 'Internal Server Error';
	end;
	Res.Content := '<html><head><title>' + AnException.ClassName + '</title></head><body><h1>' + AnException.ClassName + '</h1>' + AnException.Message + '<hr><i>Crawl HTTP Server</i></body></html>';

	handled := true;
end;

var
	I : Integer;

begin
	I := 1;

	{$ifdef unix}
	FpSignal(SIGPIPE, SignalHandler(SIG_IGN));
	{$endif}

	CrawlServerInfoDirectory := '';
	while I < ParamCount do
	begin
		if ParamStr(I) = '--directory' then
		begin
			I := I + 1;
			CrawlServerInfoDirectory := ParamStr(I) + '/';
		end;

		I := I + 1;
	end;

	HTTPRouter.RegisterRoute('/', @CrawlServerRootRoute, true);
	HTTPRouter.RegisterRoute('/data/assets/:file', @CrawlServerDataAssetsRoute);
	HTTPRouter.RegisterRoute('/data/projects/:id/:timestamp/:file', @CrawlServerDataProjectsRoute);
	HTTPRouter.RegisterRoute('/static/:file', @CrawlServerStaticRoute);

	Application.Port := StrToInt(GetEnv('CRAWL_PORT'));
	Application.Threaded := true;
	Application.OnShowRequestException := @OnShowRequestException;

	WriteLn('Server ready');

	Application.Initialize();
	Application.Run();
end.
