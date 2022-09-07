object frmFiles: TfrmFiles
  Left = 688
  Height = 602
  Top = 227
  Width = 750
  BorderStyle = bsNone
  Caption = 'frmFiles'
  ClientHeight = 602
  ClientWidth = 750
  DesignTimePPI = 120
  OnClose = FormClose
  OnShow = FormShow
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
    object ComboPath: TComboBox
      Left = 188
      Height = 28
      Top = 5
      Width = 528
      Anchors = [akTop, akLeft, akRight, akBottom]
      BorderSpacing.Around = 5
      ItemHeight = 20
      OnKeyUp = ComboPathKeyUp
      OnSelect = ComboPathSelect
      TabOrder = 0
      Text = 'ComboPath'
    end
  end
  object ListFiles: TListView
    Left = 0
    Height = 562
    Top = 40
    Width = 750
    Align = alClient
    Columns = <    
      item
        AutoSize = True
        Caption = '名称'
      end    
      item
        AutoSize = True
        Caption = '修改日期'
        Width = 80
      end    
      item
        AutoSize = True
        Caption = '文件类型'
        Width = 80
      end    
      item
        AutoSize = True
        Caption = '大小'
      end>
    ReadOnly = True
    RowSelect = True
    TabOrder = 1
    ViewStyle = vsReport
    OnDblClick = ListFilesDblClick
  end
end
