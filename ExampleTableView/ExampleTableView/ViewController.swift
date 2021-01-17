//
//  ViewController.swift
//  ExampleTableView
//
//  Created by Jim Pool Moreno on 17/01/21.
//

import UIKit
import AudioToolbox

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

        
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addButton: UIBarButtonItem!
    @IBOutlet weak var ascendentButton: UIBarButtonItem!
    @IBOutlet weak var descendentButton: UIBarButtonItem!
    
    // MARK: - Private
    private var items : [String] = []
    private var indexPage : Int = 0
    private var provincia : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setValues()
        //Delegate
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func setValues(){
        items = ["Albacete", "Alicante/Alacant", "Almería", "Araba/Álava", "Asturias", "Ávila", "Badajoz", "Balears, Illes", "Barcelona", "Bizkaia", "Burgos", "Cáceres", "Cádiz", "Cantabria", "Castellón/Castelló", "Ciudad Real", "Córdoba", "Coruña, A", "Cuenca", "Gipuzkoa", "Girona", "Granada", "Guadalajara", "Huelva", "Huesca", "Jaén", "León", "Lleida", "Lugo", "Madrid", "Málaga", "Murcia", "Navarra", "Ourense", "Palencia", "Palmas, Las", "Pontevedra", "Rioja, La", "Salamanca", "Santa Cruz de Tenerife", "Segovia", "Sevilla", "Soria", "Tarragona", "Teruel", "Toledo", "Valencia/València", "Valladolid", "Zamora", "Zaragoza", "Ceuta", "Melilla"]
        enableButtons()
        tableView.reloadData()
    }
    
    //MARK: - Enable Buttons
    func enableButtons(){
        if(items.count == 0){
            ascendentButton.isEnabled = false
            descendentButton.isEnabled = false
        }else{
            ascendentButton.isEnabled = true
            descendentButton.isEnabled = true
        }
    }
    
    //MARK: --onClick buttons
    @IBAction func clickAscending(_ sender: Any) {
        items = items.sorted { (channel1, channel2) -> Bool in
                    let channelName1 = channel1
                    let channelName2 = channel2
                    return (channelName1.localizedCaseInsensitiveCompare(channelName2) == .orderedAscending)
        }
        tableView.reloadData()
    }
    
    
    @IBAction func clickDescending(_ sender: Any) {
        items = items.sorted { (channel1, channel2) -> Bool in
                    let channelName1 = channel1
                    let channelName2 = channel2
                    return (channelName1.localizedCaseInsensitiveCompare(channelName2) == .orderedDescending)
        }
        tableView.reloadData()
    }
    
    @IBAction func clickNewProvidence(_ sender: Any) {
        alertNewProvidence()
    }
    
    //MARK: - Alert Action
    func alertNewProvidence(){
        let alertControl = UIAlertController(title: "Nueva Provincia", message: "Ingrese nueva provicia", preferredStyle: .alert)
        
        alertControl.addTextField(configurationHandler: {
            (_ textField : UITextField ) -> Void in
            textField.placeholder = "Ingrese nueva provicia"
            textField.textAlignment = .center
            textField.textColor = UIColor.blue
            textField.keyboardType = UIKeyboardType.alphabet
        })
        
        var newProvince = ""
            let actionCancel = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
            
            let saveAction = UIAlertAction(title: "Agregar", style: .default)
            { _ in
                newProvince = alertControl.textFields?[0].text ?? ""
                            
                if((newProvince.isEmpty))
                {
                    print ("Faltan campos por llenar")
                    self.toastMessage(msg: "Faltan campos por llenar")
                    AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
                }
                else{
                    self.items.append(newProvince)
                    self.enableButtons()
                    self.tableView.reloadData()
                    self.navigationController?.popViewController(animated: true)
                    print("Nueva Provicia = \(newProvince)")
                }
            }
            
            alertControl.addAction(actionCancel)
            alertControl.addAction(saveAction)
            
            self.present(alertControl, animated: true, completion: nil)
    }
    
    func alertAddText(){
        let alertControl = UIAlertController(title: "Agregar ", message: "Ingrese nueva información", preferredStyle: .alert)
        
        alertControl.addTextField(configurationHandler: {
            (_ textField : UITextField ) -> Void in
            textField.placeholder = "Nuevos datos"
            textField.textAlignment = .center
            textField.textColor = UIColor.blue
            textField.keyboardType = UIKeyboardType.alphabet
        })
        
        var newTextProvince = ""
            let actionCancel = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        
            let deleteAction = UIAlertAction(title: "Eliminar", style: .default)
            { _ in
                self.items.remove(at: self.indexPage)
                self.enableButtons()
                self.tableView.reloadData()
                self.navigationController?.popViewController(animated: true)
            }
            
            let saveAction = UIAlertAction(title: "Agregar", style: .default)
            { _ in
                newTextProvince = alertControl.textFields?[0].text ?? ""
                            
                if((newTextProvince.isEmpty))
                {
                    print ("Faltan campos por llenar")
                    self.toastMessage(msg: "Faltan campos por llenar")
                    AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
                }
                else{
                    print("Nueva texto = \(newTextProvince)")
                    //save data in shared preferences, save itself with its own name
                    UserDefaults.standard.set(newTextProvince,
                                              forKey: String(self.items[self.indexPage]))
                }
            }

            alertControl.addAction(actionCancel)
            alertControl.addAction(deleteAction)
            alertControl.addAction(saveAction)
            
            self.present(alertControl, animated: true, completion: nil)
    }
    
    //MARK: - Toast
    func toastMessage(msg: String){
        let alert = UIAlertController(title: nil, message: msg, preferredStyle: .alert)
           alert.view.backgroundColor = UIColor.black
           alert.view.alpha = 0.6
           alert.view.layer.cornerRadius = 15
           present(alert, animated: true)

        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2.0) {
               alert.dismiss(animated: true)
           }
    }
    
    // MARK: - Delegates
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return self.items.count
        return self.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = self.items[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.indexPage = indexPath.row
        print("you tapped me! \(indexPath.row)")
        self.provincia = items[indexPath.row]
        print("Provicia = \(provincia)")
        alertAddText()
    }

}

