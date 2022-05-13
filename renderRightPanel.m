function renderRightPanel()
    global system
    %% playing now text
    global playingNowText
    playingNowText=uibutton(system.rightPanel.Children(4));
    playingNowText.Text="No track playing...";
    playingNowText.Position=[-1 -1 338 79]; % klaiwwww
    playingNowText.BackgroundColor='white';
    %% slider
    global currTime
    currTime=uilabel(system.rightPanel.Children(3),'Text', '00:00','Position',[150 50 39 35]);
    startTime=uilabel(system.rightPanel.Children(3),'Text', '00:00','Position',[6 20 39 35]);
    global endTime
    endTime=uilabel(system.rightPanel.Children(3),'Text', '00:00','Position',[293 20 39 35]);
    global timeSlider
    timeSlider=uislider(system.rightPanel.Children(3),'Value',0,'Position',[50 36 234 3],'MajorTicks',[],'MinorTicks',[]);
    timeSlider.ValueChangedFcn={@moveTimeSlidder};
        function moveTimeSlidder(src, event)
            system=system.moveSlidder(timeSlider.Value);
        end
    %% track controls
    trackControls=uipanel(system.rightPanel.Children(2),'Units','normalized','Position',[0 0.5 1 0.5],'BorderType','none','BackgroundColor','white');
    backPanel=uipanel(trackControls,'Units','normalized','Position',[0 0 0.333 1],'BorderType','none','BackgroundColor','white');
    back=uibutton(backPanel,'Text', '','Icon',['icons' filesep 'left.png'],'Position',[1 1 77.9220 76],'BackgroundColor','white');
    back.ButtonPushedFcn={@playPrevious};
        function playPrevious(src,event)
            system=system.playPrevious();
        end
    PPanel=uipanel(trackControls,'Units','normalized','Position',[0.33 0 0.333 1],'BorderType','none','BackgroundColor','white');
    global p
    p=uibutton(PPanel,'Text','','Icon',['icons' filesep 'play.png'],'Position',[1 1 77.9220 76],'BackgroundColor','white');
    p.ButtonPushedFcn={@pFcn};
        function pFcn(src,event)
            if p.Icon==string(['icons' filesep 'play.png'])
                disp("play");
                system=system.readAudio(system.currentTrack);
                system=system.playAudio();
            elseif p.Icon==string(['icons' filesep 'pause.png'])
                disp("pause");
                system.pauseAudio();
            elseif p.Icon==string(['icons' filesep 'resume.png'])
                disp("resume");
                system.resumeAudio();
            end
        end
    nextPanel=uipanel(trackControls,'Units','normalized','Position',[0.66 0 0.333 1],'BorderType','none','BackgroundColor','white');
    next=uibutton(nextPanel,'Text','','Icon',['icons' filesep 'right.png'],'Position',[1 1 77.9220 76],'BackgroundColor','white');
    next.ButtonPushedFcn={@playNext};
        function playNext(src,event)
            system=system.playNext();
        end
    volume=uipanel(system.rightPanel.Children(2),'Units','normalized','Position',[0 0 1 0.5],'BorderType','none','BackgroundColor','white');
    muteButton=uibutton(system.rightPanel.Children(2),'state','Text','','Icon',['icons' filesep 'mute.png'],'Position',[1 24 30 30],'BackgroundColor','white');
    muteButton.ValueChangedFcn={@mute};
        function mute(src,event)
            system=system.mute();
        end
    volumeSlider=uislider(volume,'Value',100,'Position',[36 36 190 3],'MajorTicks',[],'MinorTicks',[]);
    volumeSlider.ValueChangedFcn={@moveVolumeSlider};
        function moveVolumeSlider(src, event)
            system=system.changeVolume(volumeSlider.Value);
        end
    %% playlist controls
    stopPanel=uipanel(system.rightPanel.Children(1),'Units','normalized','Position',[0 0 0.25 1],'BackgroundColor','white','BorderType','none');
    stop=uibutton(stopPanel,'Text','','Icon',['icons' filesep 'stop.png'],'Position',[20 20 55 55],'BackgroundColor','white','ButtonPushedFcn',@stopFcn);
        function stopFcn(src, event)
            system=system.stopAudio();
        end
    repeatPanel=uipanel(system.rightPanel.Children(1),'Units','normalized','Position',[0.25 0 0.25 1],'BackgroundColor','white','BorderType','none');
    global repeat
    repeat=uibutton(repeatPanel,'state','Text','','Icon',['icons' filesep 'repeat.png'],'Position',[20 20 55 55],'BackgroundColor','white');
    randomPanel=uipanel(system.rightPanel.Children(1),'Units','normalized','Position',[0.50 0 0.25 1],'BackgroundColor','white','BorderType','none');
    random=uibutton(randomPanel,'state','Text','','Icon',['icons' filesep 'random.png'],'Position',[20 20 55 55],'BackgroundColor','white','ValueChangedFcn',@randomFcn);
        function randomFcn(src, event)
            if random.Value==0
                system=system.derandomize();
            else
                system=system.randomize();
            end
            renderLeftPanel();
        end
    equalizerPanel=uipanel(system.rightPanel.Children(1),'Units','normalized','Position',[0.75 0 0.25 1],'BackgroundColor','white','BorderType','none');
    equalizerButton=uibutton(equalizerPanel,'Text','','Icon',['icons' filesep 'settings.png'],'Position',[20 20 55 55],'BackgroundColor','white','ButtonPushedFcn',@openEQ);
    function openEQ(src,event)
        disp("tre");
       equalizer(); 
    end
    %% subs
     global subsButton
     subsButton=uibutton(system.rightPanel.Children(5),'state','Text','','Icon',['icons' filesep 'subtitles.png'],'Position',[0 0 33.4 37.6],'BackgroundColor','white','Enable','off');
%     f=0;
%     function subsFcn(src, event)
%         
%        if subsButton.Value==1
%            f=uifigure('Name','Lyrics','Position',[960 246 280 420]);
%            lyricsPanel=uipanel(f,'Units','normalized','Position',[0 0 1 1]);
%            lyrics=uilabel(lyricsPanel);
%            lyrics.Position=[1 1 260 420];
% 
% url=strcat("https://www.google.com/search?channel=crow5&client=firefox-b-d&q=","eminem","+","venom","+lyrics");
% code=webread(url);
% tree=htmlTree(code)
% subtrees = findElement(tree,'DIV.hwc');
% str=extractHTMLText(subtrees);
% 
%            lyrics.WordWrap='on';
%            lyricsPanel.Scrollable='on';
%        else
%            close(f);
%        end
%     end

%% spotify
global spotifyButton
spotifyButton=uibutton(system.rightPanel.Children(6),'Text','','Icon',['icons' filesep 'spotify.png'],'Position',[0 0 33.4 37.6],'BackgroundColor','white','Enable','off','ButtonPushedFcn',@spotifyFcn);
    function spotifyFcn(src,event)
        system.pauseAudio();
        bearer=authorize("client_credentials");
        songID=getSongID(system.artist, system.title,bearer);
        if isempty(system.userID)
            system.userID=inputdlg("Enter Spotify ID");
        end
        playlists=getPlaylists(system.userID,bearer);
        [indx,tf] = listdlg('SelectionMode','single','ListString',playlists(:,1));
        if tf==0
            return;
        end
        disp(playlists(indx,2))
        disp(songID)
        addToPlaylist(playlists(indx,2),songID);
    end
end

