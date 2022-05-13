function addToPlaylist(playlistID,songID)
    authURI="https://accounts.spotify.com/authorize?response_type=code&client_id=a9c82462bc23488e88194dd0402f92e6&scope=playlist-modify-public playlist-modify-private&redirect_uri=http://localhost:8888/callback/";
    web(authURI,'-browser');
    code=inputdlg("Enter code found in browser");
    bearer=authorize("authorization_code&code="+code+"&redirect_uri=http://localhost:8888/callback/");
    disp(bearer);
    method=matlab.net.http.RequestMethod.POST;
    contentTypeField = matlab.net.http.field.ContentTypeField('application/json');
    authorizationField=matlab.net.http.field.GenericField("Authorization",strcat("Bearer ",bearer));
    header=[contentTypeField authorizationField];
    request = matlab.net.http.RequestMessage(method,header,[]);
    uri="https://api.spotify.com/v1/playlists/"+playlistID+"/tracks?uris=spotify%3Atrack%3A"+songID;
    resp=send(request,uri);
    x=5
end

