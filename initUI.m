function initUI()
    %% Figure
    f=uifigure('Name','Music Player');
    getpixelposition(f)
    f.CloseRequestFcn=@closeFigure;
    function closeFigure(src,event)
        delete(f); 
    end
    %% Menu
    %fileMenu = uimenu(f,'Text','&File');
    openPlaylistMenu=uimenu(f,'Text','&Open Playlist','MenuSelectedFcn',{@openPlaylist});
    savePlaylistMenu=uimenu(f,'Text','&Save Playlist','MenuSelectedFcn',{@savePlaylist});
    addTrackMenu=uimenu(f,'Text','&Add Track','MenuSelectedFcn',{@addTrack});
    %% Title Panel
    titlePanel=uipanel(f,'Units','normalized','Position',[0,0.9,1,0.1],'BackgroundColor','#FFA500');
    text=uilabel(titlePanel);
    text.Text="Music Player";
    text.Position=[232.5 0 95 42];
    %% Left Panel
    global system
    system.leftPanel=uipanel(f,'Units','normalized','Position',[0,0,0.4,0.9],'BackgroundColor','#FFFFFF');
    system.leftPanel.Scrollable='on';
    %% Right Panel
    system.rightPanel=uipanel(f,'Units','normalized','Position',[0.4,0,0.6,0.9],'BackgroundColor','#FFFFFF');
    spotifyPanel=uipanel(system.rightPanel,'Units','normalized','Position',[0.025,0.45,0.1,0.1],'BackgroundColor','#FFFFFF');
    subsControl=uipanel(system.rightPanel,'Units','normalized','Position',[0.875,0.45,0.1,0.1],'BackgroundColor','#FFFFFF');
    playingNow=uipanel(system.rightPanel,'Units','normalized','Position',[0,0.8,1,0.2],'BackgroundColor','#FFFFFF','BorderType','none');
    slider=uipanel(system.rightPanel,'Units','normalized','Position',[0,0.6,1,0.2],'BackgroundColor','#FFFFFF','BorderType','none');
    trackControls=uipanel(system.rightPanel,'Units','normalized','Position',[0.15,0.2,0.7,0.4],'BackgroundColor','#FFFFFF','BorderType','none');
    playlistControls=uipanel(system.rightPanel,'Units','normalized','Position',[0,0,1,0.2],'BackgroundColor','#FFFFFF','BorderType','none');
    renderRightPanel();
    
    function addTrack(src,event)
        [baseName, folder] = uigetfile("*.wav");
        if double(baseName)==0
            return;
        end
        system=system.addToPlaylist(baseName,fullfile(folder, baseName));
        renderLeftPanel();
    end
    function openPlaylist(src,event)
        [baseName, folder] = uigetfile("*.txt");
        if double(baseName)==0
            return;
        end
        list=readlines(fullfile(folder, baseName),"EmptyLineRule","skip");
        list=split(list);
        system=system.openPlaylist(list);
        renderLeftPanel();
    end
    function savePlaylist(src, event)
        [baseName, folder]=uiputfile('*.txt');
        if double(baseName)==0
            return;
        end
        file=fopen(fullfile(folder, baseName),'w');
        for i=1:length(system.playlist)
            fprintf(file,'%s %s\n',system.playlist(i).name, system.playlist(i).fullname);
        end
        fclose(file);
    end
end