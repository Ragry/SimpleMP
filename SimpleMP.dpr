program SimpleMP;

uses
  Vcl.Forms,
  fPlayer in 'fPlayer.pas' {frmPlayer},
  Vcl.Themes,
  Vcl.Styles,
  bass in 'bass.pas',
  QProgBar in 'Components\TQProgressBar\QProgBar.pas',
  ID3v1Tags in 'ID3v1Tags.pas',
  ID3v2Tags in 'ID3v2Tags.pas',
  AudioFiles.Declarations in 'AudioFiles.Declarations.pas',
  U_CharCode in 'U_CharCode.pas',
  ID3GenreList in 'ID3GenreList.pas',
  Id3v2Frames in 'Id3v2Frames.pas',
  reGauge in 'Components\TreGauge\reGauge.pas',
  uPlayer in 'uPlayer.pas',
  fPlaylist in 'fPlaylist.pas' {frmPlaylist},
  rePngSpeedButton in 'Components\TrePngSpeedButton\rePngSpeedButton.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmPlayer, frmPlayer);
  Application.CreateForm(TfrmPlaylist, frmPlaylist);
  Application.Run;
end.
