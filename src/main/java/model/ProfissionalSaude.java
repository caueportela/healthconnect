package model;

import lombok.*;

@Data
@AllArgsConstructor
@NoArgsConstructor

public class ProfissionalSaude {
    private long id;
    private String registro;
    private Usuario usuario;
}
