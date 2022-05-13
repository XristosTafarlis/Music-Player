function renderLeftPanel()
%     cla(panel)
    global system
    global playingNowText
    %  1.0000  339.4000  222.0000   37.6000
    playlist=system.playlist;
    for i=1:length(playlist)
        panel=uipanel(system.leftPanel,'Units','normalized','Position',[0,0.9-(i-1)/10,1,0.1],'BackgroundColor','#FFFFFF','BorderType','none');
        button=uibutton(panel,'Text',playlist(i).name,'Position',[1,1,222,37.6]);
        button.BackgroundColor='white';
        button.HorizontalAlignment='left';
        playButton=uibutton(panel,'Text','','Icon',['icons' filesep 'play.png'],'Position',[174,7.8,22,22]);
        playButton.ButtonPushedFcn={@playFcn,i};
        %deleteButton=uibutton(panel,'Text','D','Position',[198,(339.4-(i-1)*37.6)+7.8,22,22]);
        deleteButton=uibutton(panel,'Text','','Icon',['icons' filesep 'trash.png'],'Position',[198,7.8,22,22]);
        deleteButton.ButtonPushedFcn={@deleteFcn,i};
    end
    %{
    if strcmp(system.current,'')==0
        playingNowText.Text=system.current; 
    elseif ~isempty(val)
       playingNowText.Text=val(1); 
    end
    %}
    if ~isempty(playlist)
        playingNowText.Text=playlist(1).name; 
    else
        playingNowText.Text="No track playing..."; 
    end
    function playFcn(src,event,index)
        system=system.readAudio(index);
        system=system.playAudio(); 
    end
    function deleteFcn(src,event,index)
        system=system.removeFromPlaylist(index);
        delete(system.leftPanel.Children);
        renderLeftPanel();
    end
    system.leftPanel.Scrollable='on';
end

