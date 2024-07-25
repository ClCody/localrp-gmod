local scrw, scrh = ScrW(), ScrH()
function RatingMenu(ply)
    local frame = vgui.Create("DFrame")
    frame:SetSize(scrw * 0.3, scrh * 0.4)
    frame:Center()
    frame:SetDraggable(false)
    frame:SetTitle('Рейтинг игрока ' .. ply:Name())
    frame:MakePopup()

    local panel = vgui.Create("DPanel", frame)
    panel:Dock(FILL)
    panel:DockMargin(0, 0, 0, 6)
    panel:DockPadding(0, 0, 0, frame:GetTall() * 0.2)
    function panel:Paint()
        draw.RoundedBox(0, 0, 0, 0, 0, Color(0, 0, 0, 0))
    end

    local img = vgui.Create("AvatarImage", panel)
    img:Dock(LEFT)
    img:SetWide(frame:GetWide() * 0.5)
    img:DockMargin(0, 0, 0, 0)
    img:SetPlayer(ply, 128)

    local nick = vgui.Create("DLabel", panel)
    nick:Dock(FILL)
    net.Start('sb-clGetRating')
    net.WriteEntity(ply)
    net.SendToServer()
    net.Receive('sb-svGetRating', function()
        local rating = net.ReadInt(12)
        nick:SetText('Игрок: ' .. ply:Name() .. '\nРейтинг: ' .. rating)
    end)
    nick:SetFont('lrp.sb-small')

    local buttonPanel = vgui.Create("DPanel", frame)
    buttonPanel:Dock(BOTTOM)
    buttonPanel:SetTall(frame:GetTall() * 0.07)
    function buttonPanel:Paint()
        draw.RoundedBox(0, 0, 0, 0, 0, Color(0, 0, 0, 0))
    end

    local thumbUp = vgui.Create( "DButton", buttonPanel)
    thumbUp:Dock(LEFT)
    thumbUp:DockMargin(0, 0, 0, 0)
    thumbUp:SetWide(frame:GetWide() * 0.5 - 8)
    thumbUp:SetText('Положительная оценка')
    thumbUp:SetIcon('icon16/thumb_up.png')
    thumbUp.DoClick = function()
        net.Start('sb-setRating')
        net.WriteEntity(ply)
        net.WriteBool(true)
        net.SendToServer()
        frame:Close()
        RatingMenu(ply)
    end

    local thumbDown = vgui.Create( "DButton", buttonPanel)
    thumbDown:Dock(RIGHT)
    thumbDown:SetWide(frame:GetWide() * 0.5 - 8)
    thumbDown:SetText('Отрицательная оценка')
    thumbDown:SetIcon('icon16/thumb_down.png')
    thumbDown.DoClick = function()
        net.Start('sb-setRating')
        net.WriteEntity(ply)
        net.WriteBool(false)
        net.SendToServer()
        frame:Close()
        RatingMenu(ply)
    end
end