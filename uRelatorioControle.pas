unit uRelatorioControle;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, uCadastroPadrao, StdCtrls, ExtCtrls, Buttons, DB,
  ZAbstractRODataset, ZAbstractDataset, ZDataset, ppProd, ppClass,
  ppReport, ppComm, ppRelatv, ppDB, ppDBPipe, ppBands, ppCtrls, ppVar,
  ppPrnabl, ppCache, ComCtrls, jpeg;

type
  TfrmRelatorioControle = class(TfrmCadastroPadrao)
    SpeedButton1: TSpeedButton;
    Label2: TLabel;
    edtPaciente: TEdit;
    rgStatus: TRadioGroup;
    rgOrdenar: TRadioGroup;
    btnVisualizar: TBitBtn;
    ppDBPipeline1: TppDBPipeline;
    ppReport1: TppReport;
    qryPadraoCdigo: TIntegerField;
    qryPadraoDtEntrada: TDateField;
    qryPadraoPaciente: TStringField;
    qryPadraoCliente: TStringField;
    qryPadraoAparelho: TStringField;
    qryPadraoQtd: TStringField;
    qryPadraoStatus: TStringField;
    qryPadraoDtSada: TDateField;
    ppHeaderBand1: TppHeaderBand;
    ppDetailBand1: TppDetailBand;
    ppFooterBand1: TppFooterBand;
    ppLabel2: TppLabel;
    ppSystemVariable1: TppSystemVariable;
    ppSystemVariable2: TppSystemVariable;
    ppDBText1: TppDBText;
    ppLabel1: TppLabel;
    ppLabel3: TppLabel;
    ppDBText2: TppDBText;
    ppLabel4: TppLabel;
    ppDBText3: TppDBText;
    ppLabel5: TppLabel;
    ppDBText4: TppDBText;
    ppLabel6: TppLabel;
    ppDBText5: TppDBText;
    ppLabel7: TppLabel;
    ppDBText6: TppDBText;
    ppLabel8: TppLabel;
    ppDBText7: TppDBText;
    ppLabel9: TppLabel;
    ppDBText8: TppDBText;
    ppLine1: TppLine;
    ppLine2: TppLine;
    ppSummaryBand1: TppSummaryBand;
    ppLine3: TppLine;
    ppLabel10: TppLabel;
    ppLabel11: TppLabel;
    ppLine4: TppLine;
    ppDBCalc1: TppDBCalc;
    ppLabel12: TppLabel;
    dtInicio: TDateTimePicker;
    Label3: TLabel;
    Label4: TLabel;
    dtFinal: TDateTimePicker;
    procedure SpeedButton1Click(Sender: TObject);
    procedure edtCodigoKeyPress(Sender: TObject; var Key: Char);
    procedure btnVisualizarClick(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmRelatorioControle: TfrmRelatorioControle;

implementation
uses uPesquisaCliente, uPrincipalOrtoControl, DateUtils;
{$R *.dfm}

procedure TfrmRelatorioControle.SpeedButton1Click(Sender: TObject);
begin
  inherited;

  frmPesquisaCliente := TfrmPesquisaCliente.Create(Application);
  frmPesquisaCliente.ShowModal;
  edtPaciente.SetFocus;
  frmPesquisaCliente.Free;

end;

procedure TfrmRelatorioControle.edtCodigoKeyPress(Sender: TObject;
  var Key: Char);
begin
  inherited;
  if key = #13 then
  begin
    frmPesquisaCliente := TfrmPesquisaCliente.Create(Application);
    frmPesquisaCliente.edtCliente.Text := edtCodigo.Text;
    frmPesquisaCliente.BuscarCliente;
    frmPesquisaCliente.ShowModal;
    edtPaciente.SetFocus;
    frmPesquisaCliente.Free;
  end;

end;

procedure TfrmRelatorioControle.btnVisualizarClick(Sender: TObject);
begin
  inherited;

  with qryPadrao do
  begin
    Close;
    sql.Clear;
    sql.Add('select c.i_cod_controle "C�digo",                                                                    ');
    sql.Add('       c.dt_entrada_controle "Dt Entrada",                                                           ');
    sql.Add('       c.s_nome_paciente_controle "Paciente",                                                        ');
    sql.Add('       cl.s_nome_cliente "Cliente",                                                                  ');
    sql.Add('       c.s_descricao_aparelho_controle "Aparelho",                                                   ');
    sql.Add('       c.s_qtd_modelo_controle "Qtd",                                                                ');
    sql.Add('       c.s_status_controle "Status",                                                                 ');
    sql.Add('       c.dt_saida_controle "Dt Sa�da"                                                                ');
    sql.Add('from controle c                                                                                      ');
    sql.Add('       inner join cliente cl                                                                         ');
    sql.Add('         on (c.i_cod_cliente = cl.i_cod_cliente)                                                     ');
    sql.Add('where c.s_nome_paciente_controle like ' + QuotedStr('%' + edtPaciente.Text + '%')                     );
    sql.Add('  and c.dt_entrada_controle  between (:P_DT_INICIO) and (:P_DT_FINAL)                                ');
    ParamByName('P_DT_INICIO').AsDate := dtInicio.Date;
    ParamByName('P_DT_FINAL').AsDate := dtFinal.Date;
    
    if edtCodigo.Text <> '' then
    sql.Add('  and c.i_cod_cliente = ' + Copy(edtCodigo.Text, 0, Pos('-', edtCodigo.Text)- 2 )                     );

    case rgStatus.ItemIndex of

      0 : sql.Add('  and c.s_status_controle = ' + QuotedStr('Em Aberto'));
      1 : sql.Add('  and c.s_status_controle = ' + QuotedStr('Correio'));
      2 : //N�o faz nada;
    end;

    case rgOrdenar.ItemIndex of
      0 : sql.Add('order by c.i_cod_controle');
      1 : sql.Add('order by c.i_cod_cliente');
      2 : sql.Add('order by c.s_status_controle desc');
    end;

    Open;
    ppReport1.Print;

  end;




end;

procedure TfrmRelatorioControle.BitBtn2Click(Sender: TObject);
begin
  inherited;
  close;
end;

procedure TfrmRelatorioControle.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  inherited;

  if key = VK_ESCAPE THEN
  close;

end;

procedure TfrmRelatorioControle.FormShow(Sender: TObject);
var
  hoje : TDateTime;
begin
  inherited;

  hoje := now;
  dtInicio.Date := IncDay(hoje, -30);
  dtInicio.SetFocus;
  
end;

end.
