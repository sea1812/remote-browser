object frmFiles: TfrmFiles
  Left = 685
  Height = 602
  Top = 227
  Width = 750
  Caption = 'frmFiles'
  ClientHeight = 602
  ClientWidth = 750
  DesignTimePPI = 120
  OnClose = FormClose
  LCLVersion = '6.3'
  object StatusBar1: TCyPanel
    Left = 0
    Height = 40
    Top = 0
    Width = 750
    Align = alTop
    Alignment = taLeftJustify
    DoubleBuffered = True
    TabOrder = 0
    Bevels = <>
    Degrade.Balance = 100
    Degrade.BalanceMode = bmMirror
    Degrade.FromColor = clBtnFace
    Degrade.SpeedPercent = 1
    Degrade.ToColor = clMoneyGreen
    object SpeedButton1: TSpeedButton
      Left = 721
      Height = 40
      Top = 0
      Width = 29
      Align = alRight
      Caption = 'X'
      Flat = True
      OnClick = SpeedButton1Click
    end
    object ComboBox1: TComboBox
      Left = 188
      Height = 28
      Top = 5
      Width = 528
      Anchors = [akTop, akLeft, akRight, akBottom]
      BorderSpacing.Around = 5
      ItemHeight = 20
      TabOrder = 0
      Text = 'ComboBox1'
    end
  end
  object ListView1: TListView
    Left = 0
    Height = 562
    Top = 40
    Width = 750
    Align = alClient
    Columns = <    
      item
        Caption = '名称'
        Width = 120
      end    
      item
        Caption = '修改日期'
        Width = 120
      end    
      item
        Caption = '文件类型'
        Width = 120
      end    
      item
        Caption = '大小'
        Width = 120
      end>
    TabOrder = 1
    ViewStyle = vsReport
  end
end
