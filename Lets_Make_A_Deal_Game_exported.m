classdef Lets_Make_A_Deal_Game_exported < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                     matlab.ui.Figure
        HasilLabel                   matlab.ui.control.Label
        TukarButton                  matlab.ui.control.Button
        MulaiButton                  matlab.ui.control.Button
        TetapButton                  matlab.ui.control.Button
        PilihlahSatuPintuPanel       matlab.ui.container.Panel
        LevelPermainanDropDown       matlab.ui.control.DropDown
        LevelPermainanDropDownLabel  matlab.ui.control.Label
        WelcometotheLetsMakeADealGameGoodLuck_Label  matlab.ui.control.Label
    end

    
    properties (Access = private)
        PintuHadiah
        PintuDipilih
        PintuDibuka
        JumlahPintu
    end
    

    % Callbacks that handle component events
    methods (Access = private)

        % Button pushed function: MulaiButton
        function MulaiButtonPushed(app, event)
            app.HasilLabel.Text = "Pilihlah Satu Pintu";
            app.PintuDipilih = [];
            app.PintuDibuka = [];


        Mode = app.LevelPermainanDropDown.Value
        switch Mode
            case '3 Pintu', app.JumlahPintu = 3;
            case '5 Pintu', app.JumlahPintu = 5;
        end
        app.PintuHadiah = randi(app.JumlahPintu);
        delete(app.PilihlahSatuPintuPanel.Children);

        %Memperbarui Pilihan Pemain
        app.HasilLabel.Text = sprintf(' Mode %s. Pilihlah Satu Pintu yaa^_^',Mode);
        %Tampilan Pada Panel
        winWidth = app.PilihlahSatuPintuPanel.Position(3); %lebar panel
        winHeight = app.PilihlahSatuPintuPanel.Position(4); %tinggi panel
        doorWidth  = 80;
        doorHeight = 150;
        spacing = (winWidth - app.JumlahPintu*doorWidth) / (app.JumlahPintu+1);
        yPos = winHeight/2 - doorHeight/1.75; %agar posisi pintu ditengah dan vertikal

        %Membuat tombol sesuai mode
        for i = 1:app.JumlahPintu
            xPos = spacing*i + doorWidth*(i-1);
            uibutton(app.PilihlahSatuPintuPanel, 'Text', sprintf('Pintu %d', i), .....
                'Position', [xPos yPos doorWidth doorHeight], ......
                'ButtonPushedFcn' , @(btn,event) app.DoorButtonPushed(i));
            btn.FontColor = [1 1 1]; % tulisan jadi putih biar kontras
        end
     end

        function DoorButtonPushed(app, doorNum)
            if isempty(app.PintuDipilih)
                app.PintuDipilih = doorNum;
                app.HasilLabel.Text = "Pilih Pintu "+doorNum+". Membuka Pintu dann.... zonk:(";
                pause(1);
                app.openHostDoor();
            else
                app.HasilLabel.Text = "Tetap atau Tukar!";
            end
            
        end

        function openHostDoor(app)
          c = setdiff(1:app.JumlahPintu,[app.PintuDipilih, app.PintuDibuka, app.PintuHadiah]);
            if ~isempty(c)
                openDoor = c(randi(numel(c)));
                app.PintuDibuka(end+1) = openDoor;
                btns = app.PilihlahSatuPintuPanel.Children;
                btn = btns(app.JumlahPintu - openDoor + 1);
                btn.Text = "ZONK!";
                btn.Enable = 'off';
                btn.BackgroundColor = [0.8 0.8 0.8];   
            end
            app.HasilLabel.Text = "Tetap atau Tukar?";
        end

        % Button pushed function: TetapButton
        function TetapButtonPushed(app, event)
            app.HasilLabel.Text = "Tetap pada pintu "+app.PintuDipilih;
            app.nextRound();
        end

        % Button pushed function: TukarButton
        function TukarButtonPushed(app, event)
            app.HasilLabel.Text = "Klik pintu yang lain!";
            app.PintuDipilih = [];
        end

        function nextRound(app)
           remaining = setdiff(1:app.JumlahPintu, app.PintuDibuka);
            if numel(remaining) > 2
                pause(1); app.openHostDoor();
            else
                btns = app.PilihlahSatuPintuPanel.Children;
                for i=1:app.JumlahPintu
                    btn = btns(app.JumlahPintu - i + 1);
                    if i==app.PintuHadiah
                        btn.Text = "HADIAH!";
                        btn.BackgroundColor = [0.5 1 0.5];
                    else
                        btn.Text = "ZONK!";
                        btn.BackgroundColor = [1 0.5 0.5];
                    end
                    btn.Enable = 'off';
                end
                if app.PintuDipilih==app.PintuHadiah
                    app.HasilLabel.Text=" SELAMAT ANDA MENANG! ^_^ ";
                else
                   app.HasilLabel.Text ="SAYANG SEKALI, ANDA KALAH :( Hadiahnya di pintu "+app.PintuHadiah;
                end
            end 
        
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Color = [0.3294 0.3216 0.3216];
            app.UIFigure.Position = [100 100 640 480];
            app.UIFigure.Name = 'MATLAB App';

            % Create WelcometotheLetsMakeADealGameGoodLuck_Label
            app.WelcometotheLetsMakeADealGameGoodLuck_Label = uilabel(app.UIFigure);
            app.WelcometotheLetsMakeADealGameGoodLuck_Label.HorizontalAlignment = 'center';
            app.WelcometotheLetsMakeADealGameGoodLuck_Label.FontName = 'MS Gothic';
            app.WelcometotheLetsMakeADealGameGoodLuck_Label.FontSize = 18;
            app.WelcometotheLetsMakeADealGameGoodLuck_Label.Position = [38 398 566 83];
            app.WelcometotheLetsMakeADealGameGoodLuck_Label.Text = 'Welcome to the Let''s Make A Deal Game!!!!  Good Luck ^_^';

            % Create PilihlahSatuPintuPanel
            app.PilihlahSatuPintuPanel = uipanel(app.UIFigure);
            app.PilihlahSatuPintuPanel.Title = 'Pilihlah Satu Pintu!!!!';
            app.PilihlahSatuPintuPanel.BackgroundColor = [0.6588 0.4549 0.5961];
            app.PilihlahSatuPintuPanel.Position = [33 89 571 268];

            % Create LevelPermainanDropDownLabel
            app.LevelPermainanDropDownLabel = uilabel(app.PilihlahSatuPintuPanel);
            app.LevelPermainanDropDownLabel.BackgroundColor = [0.149 0.149 0.149];
            app.LevelPermainanDropDownLabel.HorizontalAlignment = 'right';
            app.LevelPermainanDropDownLabel.Position = [359 245 95 22];
            app.LevelPermainanDropDownLabel.Text = 'Level Permainan';

            % Create LevelPermainanDropDown
            app.LevelPermainanDropDown = uidropdown(app.PilihlahSatuPintuPanel);
            app.LevelPermainanDropDown.Items = {'3 Pintu', '5 Pintu'};
            app.LevelPermainanDropDown.BackgroundColor = [0.149 0.149 0.149];
            app.LevelPermainanDropDown.Position = [469 245 92 22];
            app.LevelPermainanDropDown.Value = '3 Pintu';

            % Create TetapButton
            app.TetapButton = uibutton(app.UIFigure, 'push');
            app.TetapButton.ButtonPushedFcn = createCallbackFcn(app, @TetapButtonPushed, true);
            app.TetapButton.BackgroundColor = [0.4196 0.7216 0.3608];
            app.TetapButton.Position = [33 377 146 30];
            app.TetapButton.Text = 'Tetap';

            % Create MulaiButton
            app.MulaiButton = uibutton(app.UIFigure, 'push');
            app.MulaiButton.ButtonPushedFcn = createCallbackFcn(app, @MulaiButtonPushed, true);
            app.MulaiButton.BackgroundColor = [0 0 0];
            app.MulaiButton.Position = [246 377 146 30];
            app.MulaiButton.Text = 'Mulai';

            % Create TukarButton
            app.TukarButton = uibutton(app.UIFigure, 'push');
            app.TukarButton.ButtonPushedFcn = createCallbackFcn(app, @TukarButtonPushed, true);
            app.TukarButton.BackgroundColor = [0.8 0.2314 0.2314];
            app.TukarButton.Position = [448 377 146 30];
            app.TukarButton.Text = 'Tukar';

            % Create HasilLabel
            app.HasilLabel = uilabel(app.UIFigure);
            app.HasilLabel.HorizontalAlignment = 'center';
            app.HasilLabel.FontName = 'MS Gothic';
            app.HasilLabel.FontSize = 14;
            app.HasilLabel.Position = [38 27 566 48];
            app.HasilLabel.Text = 'Hasil';

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = Lets_Make_A_Deal_Game_exported

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.UIFigure)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.UIFigure)
        end
    end
end