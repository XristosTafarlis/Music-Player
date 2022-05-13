function songID = getSongID(artist, title,bearer)
    method=matlab.net.http.RequestMethod.GET;
    contentTypeField = matlab.net.http.field.ContentTypeField('application/json');
    authorizationField=matlab.net.http.field.GenericField("Authorization",strcat("Bearer ",bearer));
    header=[contentTypeField authorizationField];
    request = matlab.net.http.RequestMessage(method,header);
    uri="https://api.spotify.com/v1/search?q="+strrep(title,' ','%20')+"+"+strrep(artist,' ','%20')+"&type=track&limit=1";
    resp=send(request,uri);
    songID=resp.Body.Data.tracks.items.id;
end

