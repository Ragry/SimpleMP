unit rePngSpeedButton;

interface

uses
  System.Types, System.Classes, Vcl.Buttons, Vcl.Graphics, Vcl.Themes, Winapi.Windows, Winapi.UxTheme;

type
  TrePngSpeedButton = class(TSpeedButton)
  protected
    procedure Paint; override;
  end;

implementation

{ TrePngSpeedButton }

Procedure Register;
begin
  RegisterComponents('Samples', [TrePngSpeedButton]);
end;

procedure TrePngSpeedButton.Paint;
var
  PaintRect: TRect;
  DrawFlags: Integer;
  Offset: TPoint;
  LGlassPaint: Boolean;
  Button: TThemedButton;
  ToolButton: TThemedToolBar;
  Details: TThemedElementDetails;
  LStyle: TCustomStyleServices;
  MemDC: HDC;
  PaintBuffer: HPAINTBUFFER;
  LCanvas: TCanvas;
begin
//  if not Enabled then
//  begin
//    FState := bsDisabled;
//    FDragging := False;
//  end
//  else if FState = bsDisabled then
//    if FDown and (GroupIndex <> 0) then
//      FState := bsExclusive
//    else
//      FState := bsUp;
//  Canvas.Font := Self.Font;
//  if ThemeControl(Self) then
//  begin
//    LStyle := StyleServices(Self);
//    LGlassPaint := csGlassPaint in ControlState;
//    if LGlassPaint then
//      PaintBuffer := BeginBufferedPaint(Canvas.Handle, ClientRect, BPBF_TOPDOWNDIB, nil, MemDC)
//    else PaintBuffer := 0;
//    LCanvas := TCanvas.Create;
//    try
//      if LGlassPaint then
//        LCanvas.Handle := MemDC
//      else LCanvas.Handle := Canvas.Handle;
//
//      LCanvas.Font := Self.Font;
//
//      if not LGlassPaint then
//        if Transparent then
//          LStyle.DrawParentBackground(0, LCanvas.Handle, nil, True)
//        else
//          PerformEraseBackground(Self, LCanvas.Handle)
//      else
//        FillRect(LCanvas.Handle, ClientRect, GetStockObject(BLACK_BRUSH));
//
//      if not Enabled then
//        Button := tbPushButtonDisabled
//      else
//        if FState in [bsDown, bsExclusive] then
//          Button := tbPushButtonPressed
//        else
//          if MouseInControl then
//            Button := tbPushButtonHot
//          else
//            Button := tbPushButtonNormal;
//
//      ToolButton := ttbToolbarDontCare;
//      if FFlat or IsCustomStyleActive then
//      begin
//        case Button of
//          tbPushButtonDisabled:
//            Toolbutton := ttbButtonDisabled;
//          tbPushButtonPressed:
//            Toolbutton := ttbButtonPressed;
//          tbPushButtonHot:
//            Toolbutton := ttbButtonHot;
//          tbPushButtonNormal:
//            Toolbutton := ttbButtonNormal;
//        end;
//      end;
//
//      PaintRect := ClientRect;
//      if ToolButton = ttbToolbarDontCare then
//      begin
//        Details := LStyle.GetElementDetails(Button);
//        LStyle.DrawElement(LCanvas.Handle, Details, PaintRect);
//        LStyle.GetElementContentRect(LCanvas.Handle, Details, PaintRect, PaintRect);
//      end
//      else
//      begin
//        Details := LStyle.GetElementDetails(ToolButton);
//        if not IsCustomStyleActive then
//        begin
//          LStyle.DrawElement(LCanvas.Handle, Details, PaintRect);
//          // Windows theme services doesn't paint disabled toolbuttons
//          // with grayed text (as it appears in an actual toolbar). To workaround,
//          // retrieve Details for a disabled button for drawing the caption.
//          if (ToolButton = ttbButtonDisabled) then
//            Details := LStyle.GetElementDetails(Button);
//        end
//        else
//        begin
//          // Special case for flat speedbuttons with custom styles. The assumptions
//          // made about the look of ToolBar buttons may not apply, so only paint
//          // the hot and pressed states , leaving normal/disabled to appear flat.
//          if not FFlat or ((Button = tbPushButtonPressed) or (Button = tbPushButtonHot)) then
//            LStyle.DrawElement(LCanvas.Handle, Details, PaintRect);
//        end;
//        LStyle.GetElementContentRect(LCanvas.Handle, Details, PaintRect, PaintRect);
//      end;
//
//      Offset := Point(0, 0);
//      if Button = tbPushButtonPressed then
//      begin
//        // A pressed "flat" speed button has white text in XP, but the Themes
//        // API won't render it as such, so we need to hack it.
//        if (ToolButton <> ttbToolbarDontCare) and not CheckWin32Version(6) then
//          LCanvas.Font.Color := clHighlightText
//        else
//          if FFlat then
//            Offset := Point(1, 0);
//      end;
//
//      TButtonGlyph(FGlyph).FPaintOnGlass := LGlassPaint;
//      TButtonGlyph(FGlyph).FThemeDetails := Details;
//      TButtonGlyph(FGlyph).FThemesEnabled := True;
//      TButtonGlyph(FGlyph).FThemeTextColor := seFont in StyleElements;
//      TButtonGlyph(FGlyph).Draw(LCanvas, PaintRect, Offset, Caption, FLayout,
//        FMargin, FSpacing, FState, Transparent, DrawTextBiDiModeFlags(0), FMouseInControl);
//
//    finally
//      LCanvas.Handle := 0;
//      LCanvas.Free;
//      if LGlassPaint then
//        EndBufferedPaint(PaintBuffer, True);
//    end
//  end
//  else
//  begin
//    PaintRect := Rect(0, 0, Width, Height);
//    if not FFlat then
//    begin
//      DrawFlags := DFCS_BUTTONPUSH or DFCS_ADJUSTRECT;
//      if FState in [bsDown, bsExclusive] then
//        DrawFlags := DrawFlags or DFCS_PUSHED;
//      DrawFrameControl(Canvas.Handle, PaintRect, DFC_BUTTON, DrawFlags);
//    end
//    else
//    begin
//      if (FState in [bsDown, bsExclusive]) or
//        (FMouseInControl and (FState <> bsDisabled)) or
//        (csDesigning in ComponentState) then
//        DrawEdge(Canvas.Handle, PaintRect, DownStyles[FState in [bsDown, bsExclusive]],
//          FillStyles[Transparent] or BF_RECT)
//      else if not Transparent then
//      begin
//        Canvas.Brush.Color := Color;
//        Canvas.FillRect(PaintRect);
//      end;
//      InflateRect(PaintRect, -1, -1);
//    end;
//    if FState in [bsDown, bsExclusive] then
//    begin
//      if (FState = bsExclusive) and (not FFlat or not FMouseInControl) then
//      begin
//        Canvas.Brush.Bitmap := AllocPatternBitmap(clBtnFace, clBtnHighlight);
//        Canvas.FillRect(PaintRect);
//      end;
//      Offset.X := 1;
//      Offset.Y := 1;
//    end
//    else
//    begin
//      Offset.X := 0;
//      Offset.Y := 0;
//    end;
//
//    LStyle := StyleServices(Self);
//    TButtonGlyph(FGlyph).FThemesEnabled := LStyle.Enabled;

    Canvas.Brush.Color := clGreen;
    Canvas.FillRect(PaintRect);
//    TButtonGlyph(FGlyph).Draw(Canvas, PaintRect, Offset, Caption, FLayout, FMargin,
//      FSpacing, FState, Transparent, DrawTextBiDiModeFlags(0));
//  end;
end;

end.
