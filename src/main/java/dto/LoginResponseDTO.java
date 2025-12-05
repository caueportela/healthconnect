package dto;

import lombok.Data;

@Data
public class LoginResponseDTO {
    private long id;
    private String email;
    private String tipo;

    public LoginResponseDTO(long id, String email, String tipo) {
        this.id = id;
        this.email = email;
        this.tipo = tipo;
    }
}
