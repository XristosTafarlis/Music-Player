function equalizer()
    eq=uifigure;

    Hz60Label=uilabel(eq,'Text','60Hz','Position',[150 390 100 15]);
    Hz170Label=uilabel(eq,'Text','170Hz','Position',[150 340 100 15]);
    Hz310Label=uilabel(eq,'Text','310Hz','Position',[150 290 100 15]);
    Hz600Label=uilabel(eq,'Text','600Hz','Position',[150 240 100 15]);
    KHz1Label=uilabel(eq,'Text','1KHz','Position',[150 190 100 15]);
    KHz3Label=uilabel(eq,'Text','3KHz','Position',[150 140 100 15]);
    KHz6Label=uilabel(eq,'Text','6KHz','Position',[150 90 100 15]);
    KHz12Label=uilabel(eq,'Text','12KHz','Position',[150 40 100 15]);
    global system
    Hz60Slider=uislider(eq,'Position',[200 400 200 3],'Limits',[-1 1],'Value',system.Hz60);
    Hz170Slider=uislider(eq,'Position',[200 350 200 3],'Limits',[-1 1],'Value',system.Hz170);
    Hz310Slider=uislider(eq,'Position',[200 300 200 3],'Limits',[-1 1],'Value',system.Hz310);
    Hz600Slider=uislider(eq,'Position',[200 250 200 3],'Limits',[-1 1],'Value',system.Hz600);
    KHz1Slider=uislider(eq,'Position',[200 200 200 3],'Limits',[-1 1],'Value',system.KHz1);
    KHz3Slider=uislider(eq,'Position',[200 150 200 3],'Limits',[-1 1],'Value',system.KHz3);
    KHz6Slider=uislider(eq,'Position',[200 100 200 3],'Limits',[-1 1],'Value',system.KHz6);
    KHz12Slider=uislider(eq,'Position',[200 50 200 3],'Limits',[-1 1],'Value',system.KHz12);
    resetButton=uibutton(eq,'Text','Reset');
    resetButton.Position(1)=450;
    resetButton.Position(2)=60;
    resetButton.ButtonPushedFcn=@resetSliders;
    function resetSliders(src,event)
        Hz60Slider.Value=0;
        Hz170Slider.Value=0;
        Hz310Slider.Value=0;
        Hz600Slider.Value=0;
        KHz1Slider.Value=0;
        KHz3Slider.Value=0;
        KHz6Slider.Value=0;
        KHz12Slider.Value=0;
    end
    applyButton=uibutton(eq,'Text','Apply');
    applyButton.Position(1)=450;
    applyButton.Position(2)=25;
    applyButton.ButtonPushedFcn=@applyEQFcn;
    function applyEQFcn(src, event)
        
        system.Hz60=Hz60Slider.Value;
        system.Hz170=Hz170Slider.Value;
        system.Hz310=Hz310Slider.Value;
        system.Hz600=Hz600Slider.Value;
        system.KHz1=KHz1Slider.Value;
        system.KHz3=KHz3Slider.Value;
        system.KHz6=KHz6Slider.Value;
        system.KHz12=KHz12Slider.Value;
        system=system.playAudio();
    end
end