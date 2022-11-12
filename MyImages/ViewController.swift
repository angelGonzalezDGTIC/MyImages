//
//  ViewController.swift
//  MyImages
//
//  Created by Ángel González on 05/11/22.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {

    var ipc: UIImagePickerController!
    let btnFoto=UIButton(type: .custom)
    var imgContainer:UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imgContainer = UIImageView(frame: CGRect(x: 0, y: 100, width: 240, height: 130))
        imgContainer.backgroundColor = .brown
        imgContainer.contentMode = .scaleAspectFit
        imgContainer.translatesAutoresizingMaskIntoConstraints=true
        imgContainer.center.x = self.view.center.x
        self.view.addSubview(imgContainer)
        
        btnFoto.setImage(UIImage(systemName: "camera.fill"), for:.normal)
        btnFoto.autoresizingMask = .flexibleWidth
        btnFoto.translatesAutoresizingMaskIntoConstraints=true
        btnFoto.frame=CGRect(x:(self.view.frame.width-100) / 2, y: 300, width: 100, height: 40)
        self.view.addSubview(btnFoto)
        btnFoto.addTarget(self, action:#selector(btnFotoTouch), for:.touchUpInside)
    }
    
    @objc func btnFotoTouch () {
        ipc = UIImagePickerController()
        // asignamos el delegado para controlar los eventos de elección y edición de foto
        ipc.delegate = self
        // permitir edición (recorte) de la foto elegida
        ipc.allowsEditing = true
        // 1. Elegir una foto de la libreria
        // ipc.sourceType = .photoLibrary
        // 2. Usar la cámara para tomar una nueva foto
        
        // Primero comprobamos si la cámara está disponible
        if (UIImagePickerController.isSourceTypeAvailable(.camera)) {
            ipc.sourceType = UIImagePickerController.SourceType.camera
        }
        else {
            ipc.sourceType = .photoLibrary
        }
        self.present(ipc, animated: true)
    }

    // este método se invoca cuando el usuario eligió una imagen
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // si configuramos que se permitía la edición, entonces la imagen llega en la llave .editedImage
        if let imagen = info[.editedImage] as? UIImage {
            imgContainer.image = imagen
            // para convertir la imagen a un objeto tipo Data (arreglo de bytes):
            let bytes = imagen.jpegData(compressionQuality:0.5) // Imagen al 50% de su tamaño real
            // confirmar si es una imagen nueva y hay que guardarla en la librería:
            if ipc.sourceType == .camera {
                // guardar la imagen en la librería:
                //UIImageWriteToSavedPhotosAlbum(imagen, nil, nil, nil)
                // o podemos guardar en el album personalizado
                MiAlbum.instance.guardar(imagen)
            }
        }
        ipc.dismiss(animated: true)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // El usuario canceló la elección de foto
        ipc.dismiss(animated: true)
    }
}

