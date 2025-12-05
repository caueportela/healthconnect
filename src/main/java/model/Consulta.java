package model;

import lombok.*;

import java.time.LocalDateTime;

@Data
@AllArgsConstructor
@NoArgsConstructor

public class Consulta {
private long idConsulta;
private Paciente paciente;
private ProfissionalSaude profissionalSaude;
private LocalDateTime dataHora;
private String descricao;
private String status;



}
