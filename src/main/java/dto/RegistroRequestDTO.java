package dto;

import lombok.Data;

@Data
public class RegistroRequestDTO {
    private String nome;
    private String email;
    private String senha;
    private String tipo;
    private String registro;

    public RegistroRequestDTO(String nome, String email, String senha, String tipo, String registro) {
        this.nome = nome;
        this.email = email;
        this.senha = senha;
        this.tipo = tipo;
        this.registro = registro;
    }
}
