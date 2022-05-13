function playlists = getPlaylists(userID,bearer)

    method=matlab.net.http.RequestMethod.GET;
    contentTypeField = matlab.net.http.field.ContentTypeField('application/json');
    authorizationField=matlab.net.http.field.GenericField("Authorization",strcat("Bearer ",bearer));
    header=[contentTypeField authorizationField];
    request = matlab.net.http.RequestMessage(method,header);
    uri="https://api.spotify.com/v1/users/"+userID+"/playlists";
    resp=send(request,uri);
    playlists=strings(length(resp.Body.Data.items),2);
    for i=1:length(playlists)
        playlists(i,1)=resp.Body.Data.items(i).name;
        playlists(i,2)=resp.Body.Data.items(i).id;
    end
end

