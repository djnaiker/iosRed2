//
//  ViewController.swift
//  NubeIOS
//
//  Created by Ruben Lopez Diez on 20/11/15.
//  Copyright © 2015 Naiker. All rights reserved.
//

import UIKit

class ViewController: UIViewController , UITextFieldDelegate{

    @IBOutlet weak var isbn: UITextField!
    @IBOutlet weak var result: UILabel!
    @IBOutlet weak var titulo: UILabel!
    @IBOutlet weak var autores: UILabel!
    @IBOutlet weak var portada: UIImageView!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        isbn.clearButtonMode = UITextFieldViewMode.WhileEditing;
        isbn.delegate = self
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func getJSON(isbn:String){
        let url : String = "https://openlibrary.org/api/books?jscmd=data&format=json&bibkeys=ISBN:"
        let nsurl = NSURL(string: url + isbn)
        let sesion = NSURLSession.sharedSession()
        let bloque = { (datos : NSData?, resp : NSURLResponse?, error: NSError?) -> Void in
            if (error == nil){
                 self.procesarJSON(datos!)
            }else{
                
                let alert = UIAlertView()
                alert.title = "Fallo"
                alert.message = "No se ha podido conectar con el servidor"
                alert.show()            }
         
        }
        
        let dt = sesion.dataTaskWithURL(nsurl!, completionHandler: bloque)
        dt.resume()
        
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        getJSON(self.isbn.text!)
        return true;
    }
    
    func procesarJSON(json : NSData){
        do{
            let procesado = try NSJSONSerialization.JSONObjectWithData(json, options: NSJSONReadingOptions.MutableContainers)
            let libro : NSDictionary = procesado as! NSDictionary
            let contenidoLibro  =  libro["ISBN:" + self.isbn.text!]  as! NSDictionary

            let titulo : String = contenidoLibro["title"] as! String
            let autores : NSArray = contenidoLibro["authors"] as! NSArray
            let imagen : NSDictionary = contenidoLibro["cover"] as! NSDictionary



            self.titulo.text = titulo

            var autoresTemp : String  = ""
            for (var i = 0; i<autores.count; i++){
               autoresTemp += (autores[i] as! NSDictionary)["name"] as! String  + ", "
            }

            self.autores.text = autoresTemp


        }catch _{
            
        }
    }


    func downloadImage(url: NSURL){

        getDataFromUrl(url) { (data, response, error)  in
            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                guard let data = data where error == nil else {
                    return
                }
                portada.image =  UIImage(data: data)
            }
        }
    }
    
   

}

