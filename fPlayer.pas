unit fPlayer;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.Buttons, Vcl.Imaging.pngimage,
  Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.AppEvnts, Jpeg, Vcl.Samples.Gauges, reGauge, uPlayer;

type
  TfrmPlayer = class(TForm)
    Image1: TImage;
    btnPrev: TSpeedButton;
    btnStop: TSpeedButton;
    btnPlay: TSpeedButton;
    btnPause: TSpeedButton;
    btnNext: TSpeedButton;
    Edit1: TEdit;
    lblTimeCode: TLabel;
    lblTimeMax: TLabel;
    tiTrayIcon: TTrayIcon;
    aeApplicationEvents: TApplicationEvents;
    tmrRefresh: TTimer;
    Label1: TLabel;
    Label2: TLabel;
    btnMinimize: TSpeedButton;
    SpeedButton2: TSpeedButton;
    btnClose: TSpeedButton;
    Shape1: TShape;
    btnGetMp3Info: TButton;
    Image2: TImage;
    gageFilePosition: TreGauge;
    gageVolume: TreGauge;
    procedure btnPlayClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure btnStopClick(Sender: TObject);
    procedure btnPauseClick(Sender: TObject);
    procedure aeApplicationEventsMinimize(Sender: TObject);
    procedure tiTrayIconDblClick(Sender: TObject);
    procedure tmrRefreshTimer(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure btnMinimizeClick(Sender: TObject);
    procedure btnGetMp3InfoClick(Sender: TObject);
    procedure gageFilePositionMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure gageVolumeMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
  private
    FPlayer: TPlayer;
    procedure UpdateTimeCode;
  end;

var
  frmPlayer: TfrmPlayer;

implementation

{$R *.dfm}

uses ID3v1Tags, ID3v2Tags;

{ TForm1 }

procedure TfrmPlayer.btnPlayClick(Sender: TObject);
var
  Time: Cardinal;
begin
  FPlayer.Play(Edit1.Text, gageFilePosition.Progress);
  gageFilePosition.MaxValue := FPlayer.ByteLength;
  FPlayer.Volume := gageVolume.Progress / 100;
  Time := FPlayer.Duration;
  lblTimeMax.Caption := Format(' %d:%.2d', [Time div 60, Time mod 60]);
  tmrRefresh.Enabled := True;
end;

procedure TfrmPlayer.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  FPlayer.Free;
end;

procedure TfrmPlayer.FormCreate(Sender: TObject);
begin
  FPlayer := TPlayer.Create(Handle);
end;

procedure TfrmPlayer.gageFilePositionMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  ClickPosition: Integer;
begin
  tmrRefresh.Enabled := False;
  ClickPosition := MulDiv(X, gageFilePosition.MaxValue, gageFilePosition.Width) + 1;
  gageFilePosition.Progress := ClickPosition;
  FPlayer.Position := gageFilePosition.Progress;
  UpdateTimeCode;
  tmrRefresh.Enabled := True;
end;

procedure TfrmPlayer.gageVolumeMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  ClickPosition: Integer;
begin
  ClickPosition := MulDiv(gageVolume.Height - Y, gageVolume.MaxValue, gageVolume.Height) + 1;
  gageVolume.Progress := ClickPosition;
  FPlayer.Volume := gageVolume.Progress / 100;
end;

procedure TfrmPlayer.btnMinimizeClick(Sender: TObject);
begin
  WindowState := TWindowState.wsMinimized;
end;

procedure TfrmPlayer.btnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmPlayer.btnGetMp3InfoClick(Sender: TObject);
var
  id3v1: TID3v1Tag;
  id3v2: TID3v2Tag;
  stream: TMemoryStream;
  PngImage: TPngImage;
  JpegImage: TJpegImage;
begin
//  id3v1 := TID3v1Tag.Create;
//  try
//    id3v1.ReadFromFile(Edit1.Text);
//    if id3v1.TagExists then
//      ShowMessage(id3v1.Artist + ' - ' + id3v1.Title);
//  finally
//    id3v1.Free;
//  end;

  id3v2 := TID3v2Tag.Create;
  stream := TMemoryStream.Create;
  try
    id3v2.ReadFromFile(Edit1.Text);
    if id3v2.TagExists then
//      ShowMessage(id3v2.Artist + ' - ' + id3v2.Title);
//      ShowMessage(id3v2.Album);

      id3v2.GetPicture(stream, '');
      stream.Seek(0, soFromBeginning);
      JpegImage := TJpegImage.Create;
      JpegImage.LoadFromStream(stream);
      Image2.Picture.Assign(JpegImage);
  finally
    id3v2.Free;
    stream.Free;
  end;
end;

procedure TfrmPlayer.tmrRefreshTimer(Sender: TObject);
begin
  if FPlayer.GetIsActive then begin
    gageFilePosition.Progress := FPlayer.Position;
		UpdateTimeCode;
  end
  else begin
    FPlayer.Slide;
    tmrRefresh.Enabled := False;
  end;
end;

procedure TfrmPlayer.tiTrayIconDblClick(Sender: TObject);
begin
  Application.Restore;
  Application.BringToFront;
end;

procedure TfrmPlayer.UpdateTimeCode;
var
  Time: Cardinal;
begin
  if FPlayer.Playing then
    Time := FPlayer.Time
  else
    Time := 0;
  lblTimeCode.Caption := Format(' %d:%.2d', [Time div 60, Time mod 60]);
end;

procedure TfrmPlayer.btnStopClick(Sender: TObject);
begin
  FPlayer.Stop;
  gageFilePosition.Progress := 0;
end;

procedure TfrmPlayer.aeApplicationEventsMinimize(Sender: TObject);
begin
  frmPlayer.Hide;
end;

procedure TfrmPlayer.btnPauseClick(Sender: TObject);
begin
  FPlayer.Pause;
end;

end.
