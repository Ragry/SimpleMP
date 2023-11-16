unit uPlayer;

interface

uses
  System.Classes, System.SysUtils;

type
  TPlayer = class
  private
    FByteLength: Int64;
    FChannel: Cardinal;
    FDuration: Cardinal;
    FPlaying: Boolean;
    FVolume: Single;
    FOnStartPlaying: TNotifyEvent;
    function GetPosition: Int64;
    function GetTime: Int64;
    procedure SetPosition(Value: Int64);
    procedure SetVolume(Value: Single);
  public
    constructor Create(WinHandle: THandle);
    destructor Destroy; override;
    function GetIsActive: Boolean;
    procedure Pause;
    procedure Play(const FileName: string; StartPosition: Int64);
    procedure Slide;
    procedure Stop;
    property Duration: Cardinal read FDuration;
    property ByteLength: Int64 read FByteLength;
    property Playing: Boolean read FPlaying;
    property Position: Int64 read GetPosition write SetPosition;
    property Time: Int64 read GetTime;
    property Volume: Single read FVolume write SetVolume;
    property OnStartPlaying: TNotifyEvent read FOnStartPlaying write FOnStartPlaying;
  end;

implementation

uses
  bass;

{ TPlayer }

constructor TPlayer.Create(WinHandle: THandle);
begin
  FPlaying := False;
  FVolume := 100;
  if not BASS_Init(-1, 44100, 0, WinHandle, nil) then
		raise Exception.Create('Error initializing BASS!');
end;

destructor TPlayer.Destroy;
begin
  if FChannel > 0 then BASS_ChannelFree(FChannel);
	BASS_Free();
  inherited;
end;

function TPlayer.GetIsActive: Boolean;
begin
  Result := BASS_ChannelIsActive(FChannel) > 0;
end;

function TPlayer.GetPosition: Int64;
begin
  Result := BASS_ChannelGetPosition(FChannel, BASS_POS_BYTE);
end;

function TPlayer.GetTime: Int64;
begin
  Result := Trunc(BASS_ChannelBytes2Seconds(FChannel, GetPosition));
end;

procedure TPlayer.Pause;
begin
  FPlaying := False;
  BASS_ChannelPause(FChannel);
end;

procedure TPlayer.Play(const FileName: string; StartPosition: Int64);
begin
  if FPlaying then begin
    Pause;
    Exit;
  end;

  FPlaying := True;

  FChannel := BASS_StreamCreateFile(FALSE, PChar(FileName), 0, 0, BASS_UNICODE);

  FByteLength := BASS_ChannelGetLength(FChannel, BASS_POS_BYTE);
  FDuration := Trunc(BASS_ChannelBytes2Seconds(FChannel, FByteLength));

  BASS_ChannelSetPosition(FChannel, StartPosition, BASS_POS_BYTE);
  BASS_ChannelSetAttribute(FChannel, BASS_ATTRIB_VOL, FVolume);

  BASS_ChannelPlay(FChannel, False);
end;

procedure TPlayer.SetPosition(Value: Int64);
begin
  BASS_ChannelSetPosition(FChannel, Value, BASS_POS_BYTE);
end;

procedure TPlayer.SetVolume(Value: Single);
begin
  FVolume := Value;
  BASS_ChannelSetAttribute(FChannel, BASS_ATTRIB_VOL, FVolume);
end;

procedure TPlayer.Slide;
begin
  BASS_ChannelSlideAttribute(FChannel, BASS_ATTRIB_VOL, 0, 200);
  while BASS_ChannelIsSliding(FChannel, BASS_ATTRIB_VOL) do
    Sleep(1);
  FPlaying := False;
end;

procedure TPlayer.Stop;
begin
  FPlaying := False;
  BASS_ChannelStop(FChannel);
end;

end.
