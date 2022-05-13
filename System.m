classdef System
    % RENAME THIS TO CONTOLLER  MAYBE?
    properties
        currentTrack
        userID
        artist
        title
        playlist
        leftPanel
        rightPanel
        y
        Fs
        volume
        currentSample
        unmuted
        tempPlaylist
        player
        Hz60
        Hz170
        Hz310
        Hz600
        KHz1
        KHz3
        KHz6
        KHz12
        filter60
        filter170
        filter310
        filter600
        filter1000
        filter3000
        filter6000
        filter12000
    end
    methods
        function obj=System()
            obj.userID=[];
            obj.currentTrack=1;
            obj.playlist= struct('name',{},'fullname',{});
            obj.volume=100;
            obj.unmuted=1;
            obj.artist=[];
            obj.title=[];
            obj.Hz60=0;
            obj.Hz170=0;
            obj.Hz310=0;
            obj.Hz600=0;
            obj.KHz1=0;
            obj.KHz3=0;
            obj.KHz6=0;
            obj.KHz12=0;
            obj.filter60=designfilt('bandpassfir','FilterOrder',20,'CutoffFrequency1',40,'CutoffFrequency2',80,'SampleRate',48000);
            obj.filter170=designfilt('bandpassfir','FilterOrder',20,'CutoffFrequency1',150,'CutoffFrequency2',190,'SampleRate',48000);
            obj.filter310=designfilt('bandpassfir','FilterOrder',20,'CutoffFrequency1',290,'CutoffFrequency2',330,'SampleRate',48000);
            obj.filter600=designfilt('bandpassfir','FilterOrder',20,'CutoffFrequency1',580,'CutoffFrequency2',620,'SampleRate',48000);
            obj.filter1000=designfilt('bandpassfir','FilterOrder',20,'CutoffFrequency1',980,'CutoffFrequency2',1020,'SampleRate',48000);
            obj.filter3000=designfilt('bandpassfir','FilterOrder',20,'CutoffFrequency1',2980,'CutoffFrequency2',3020,'SampleRate',48000);
            obj.filter6000=designfilt('bandpassfir','FilterOrder',20,'CutoffFrequency1',5980,'CutoffFrequency2',6020,'SampleRate',48000);
            obj.filter12000=designfilt('bandpassfir','FilterOrder',20,'CutoffFrequency1',11980,'CutoffFrequency2',12020,'SampleRate',48000);
        end
        function obj=randomize(obj)
            obj.tempPlaylist=obj.playlist;
            obj.playlist=obj.playlist(randperm(length(obj.playlist)));    
        end
        function obj=derandomize(obj)
            obj.playlist=obj.tempPlaylist;
        end
        function obj=addToPlaylist(obj,name,fullname)
            tmp.name=name;
            tmp.fullname=fullname;
            obj.playlist(end+1)=tmp;
%             global player
%             if isplaying(player)
%                 obj.currentSample=player.CurrentSample;
%                 obj=obj.stopAudio();
%                 obj=obj.playAudio();
%             end
        end
        function obj=removeFromPlaylist(obj,index)
            obj.playlist(index)=[];
%             global player
%             if isplaying(player)
%                 obj.currentSample=player.CurrentSample;
%                 obj=obj.stopAudio();
%                 obj=obj.playAudio();
%             end
        end
        function obj=moveSlidder(obj,index)
            obj.currentSample=floor(index*obj.Fs)+1;
            obj=obj.playAudio();
        end
        function obj=changeVolume(obj,vol)
            obj.volume=vol;
            global player
            obj.currentSample=player.CurrentSample;
            obj=obj.playAudio();
        end
        function obj=mute(obj)
            global player
            obj.currentSample=player.CurrentSample;
            obj.unmuted=mod(obj.unmuted+1,2);
            obj=obj.playAudio();
        end
        function obj=readAudio(obj,index)
            obj.currentTrack=index;
            obj.currentSample=1;
            [obj.y,obj.Fs]=audioread(obj.playlist(index).fullname);
            info=audioinfo(obj.playlist(index).fullname);
            global subsButton
            global spotifyButton
            if isempty(info.Title) || isempty(info.Artist)
                subsButton.Enable='off';
                spotifyButton.Enable='off';
                obj.title=[];
                obj.artist=[];
            else
                %subsButton.Enable='on';
                spotifyButton.Enable='on';
                obj.title=info.Title;
                obj.artist=info.Artist;
            end
            global timeSlider
            timeSlider.Limits=[0 floor(length(obj.y)/obj.Fs)];
            global endTime
            s=seconds(length(obj.y)/obj.Fs);
            s.Format='mm:ss';
            endTime.Text=char(s);
            global playingNowText
            playingNowText.Text=obj.playlist(index).name;
        end
        function obj=playAudio(obj)
            global currTime
            global timeSlider
            global player
            filteredOut=0;
            if obj.Hz60~=0
                filteredOut=obj.Hz60*fftfilt(obj.filter60.Coefficients,obj.y);
            end
            if obj.Hz170~=0
                filteredOut=filteredOut+obj.Hz170*fftfilt(obj.filter170.Coefficients,obj.y);
            end
            if obj.Hz310~=0
                filteredOut=filteredOut+obj.Hz310*fftfilt(obj.filter310.Coefficients,obj.y);
            end
            if obj.Hz600~=0
                filteredOut=filteredOut+obj.Hz600*fftfilt(obj.filter600.Coefficients,obj.y);
            end
            if obj.KHz1~=0
                filteredOut=filteredOut+obj.KHz1*fftfilt(obj.filter1000.Coefficients,obj.y);
            end
            if obj.KHz3~=0
                filteredOut=filteredOut+obj.KHz3*fftfilt(obj.filter3000.Coefficients,obj.y);
            end
            if obj.KHz6~=0
                filteredOut=filteredOut+obj.KHz6*fftfilt(obj.filter6000.Coefficients,obj.y);
            end
            if obj.KHz12~=0
                filteredOut=filteredOut+obj.KHz12*fftfilt(obj.filter12000.Coefficients,obj.y);
            end
            player = audioplayer((obj.y+filteredOut)*(obj.volume/100)*obj.unmuted, obj.Fs);
            player.TimerFcn=@updateTime;
            player.StartFcn=@updateTime;
            player.StopFcn=@stopFunction;
            player.TimerPeriod=1;
            play(player,obj.currentSample);
            global p
            p.Icon=['icons' filesep 'pause.png'];
            function updateTime(src, event)
                timeSlider.Value=floor(player.CurrentSample/player.SampleRate);
                s=seconds(player.CurrentSample/player.SampleRate);
                s.Format='mm:ss';
                currTime.Text=char(s);
            end     
            function stopFunction(src, event)
                if timeSlider.Value==timeSlider.Limits(2) || timeSlider.Value==timeSlider.Limits(2)-1
                    %obj=obj.stopAudio();
                    obj=obj.playNext();
                end
            end
        end
        function pauseAudio(obj)
            global player
            pause(player);
            global p
            p.Icon=['icons' filesep 'resume.png'];
        end
        function resumeAudio(obj)
            global player
            resume(player);
            global p
            p.Icon=['icons' filesep 'pause.png'];
        end
        function obj=stopAudio(obj)
            global player
            stop(player);
            global p
            p.Icon=['icons' filesep 'play.png'];
        end
        function obj=playPrevious(obj)
           previousTrack=obj.currentTrack-1;
           if previousTrack<1
              previousTrack=length(obj.playlist);
           end
           obj=obj.readAudio(previousTrack);
           obj=obj.playAudio();
        end
        function obj=playNext(obj)
            global repeat
            if repeat.Value==1
                nextTrack=obj.currentTrack;
                repeat.Value=0;
            else
                nextTrack=obj.currentTrack+1;
            end
            if nextTrack>length(obj.playlist)
                nextTrack=1;
            end
            obj=obj.readAudio(nextTrack);
            obj=obj.playAudio();
        end
        function obj=openPlaylist(obj, list)
            for i=1:length(list)
               obj=obj.addToPlaylist(list(i,1),list(i,2)); 
            end
        end
    end
end

