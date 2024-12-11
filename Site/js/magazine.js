"use strict";

class MagazineElement extends HTMLElement {
    constructor() {
        super();
        this.attachShadow({ mode: "open" });
    }

    async connectedCallback() {
        // Lê os atributos do elemento
        const useFirstPage = this.getAttribute("useFirstPage") === "true";
        const pdfPath = this.getAttribute("href"); // Lê o PDF a partir do atributo href

        if (!pdfPath) {
            console.error("O atributo 'href' precisa ser definido no elemento <custom-magazine>.");
            return;
        }

        // Cria o link (<a>) que envolverá a imagem de capa
        const linkElement = document.createElement("a");
        linkElement.href = pdfPath;
        linkElement.target = "_blank"; // Abre o PDF em uma nova aba

        // Cria o elemento de imagem para a capa
        const imgElement = document.createElement("img");
        imgElement.className = "cover-image";
        if (useFirstPage) {
            // Renderiza a primeira página do PDF como imagem

            const coverImage = pdfPath.indexOf(1)
        } else {
            // Usa a imagem fornecida pelo atributo 'Foto'
            const coverImage = this.getAttribute("src");
            if (coverImage) {
                imgElement.src = coverImage;
            } else {
                console.warn("Nenhuma imagem foi fornecida para a capa.");
                return;
            }
        }

        // Adiciona a imagem ao link
        linkElement.appendChild(imgElement);

        // Adiciona o link ao Shadow DOM
        this.shadowRoot.appendChild(linkElement);
    }
}

// Define o elemento personalizado
customElements.define("custom-magazine", MagazineElement);
