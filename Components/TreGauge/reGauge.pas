unit reGauge;

interface

uses
  System.Classes, Vcl.Samples.Gauges;

type
  TreGauge = class(TGauge)
  published
    property OnMouseDown;
    property OnMouseEnter;
    property OnMouseLeave;
    property OnMouseMove;
    property OnMouseUp;
    property OnMouseWheel;
    property OnMouseWheelDown;
    property OnMouseWheelUp;
  end;

procedure Register;

implementation

Procedure Register;
begin
  RegisterComponents('Samples', [TreGauge]);
end;

end.
