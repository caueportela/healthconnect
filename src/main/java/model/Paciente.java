package model;

import lombok.*;

@Data
@AllArgsConstructor
@NoArgsConstructor

public class Paciente {
    private long id;
    private Usuario usuario;
    private String cpf;
}
