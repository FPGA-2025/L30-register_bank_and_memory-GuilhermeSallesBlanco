module Memory #(
    parameter MEMORY_FILE = "",
    parameter MEMORY_SIZE = 4096
)(
    input  wire        clk,

    input  wire        rd_en_i,    // Indica uma solicitação de leitura
    input  wire        wr_en_i,    // Indica uma solicitação de escrita

    input  wire [31:0] addr_i,     // Endereço
    input  wire [31:0] data_i,     // Dados de entrada (para escrita)
    output wire [31:0] data_o,     // Dados de saída (para leitura)

    output wire        ack_o       // Confirmação da transação
);

reg [31:0] memory [0:MEMORY_SIZE-1]; // Memória de 32 bits
reg [31:0] _data_o; // Registrador para saída de dados
reg _ack_o; // Registrador para confirmação

initial begin
    if(MEMORY_FILE != "") begin
        $readmemh(MEMORY_FILE, memory); // Carrega o arquivo de memória se especificado
    end
end

always @(posedge clk) begin
    _ack_o <= 1'b0; // Reseta a confirmação a cada ciclo de clock
    _data_o <= 32'b0; // Reseta os dados de saída a cada ciclo de clock
    if(rd_en_i) begin
        _ack_o <= 1'b1; // Confirmação de leitura
        _data_o <= memory[addr_i[31:2]]; // Lê da memória
    end else if(wr_en_i) begin
        _ack_o <= 1'b1; // Confirmação de escrita
        memory[addr_i[31:2]] <= data_i; // Escreve na memória
    end
end

assign data_o = _data_o; // Atribui os dados de saída
assign ack_o = _ack_o; // Atribui a confirmação

endmodule
