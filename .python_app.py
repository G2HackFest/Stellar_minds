from kivy.app import App
from kivy.uix.boxlayout import BoxLayout
from kivy.uix.label import Label
from kivy.uix.textinput import TextInput
from kivy.uix.button import Button

# Sample data
child_info = {
    "name": "John Doe",
    "age": "15",
    "address": "123 Street, City",
    "mobile": "9876543210",
    "attendance": "90%",
    "overall_attendance": "85%",
    "marks": {"Math": 95, "Science": 89, "English": 92},
    "total_grade": "A",
    "holidays": "10 Days",
    "cgpa": "8.9"
}

class LoginScreen(BoxLayout):
    def _init_(self, **kwargs):
        super()._init_(orientation='vertical', **kwargs)
        self.add_widget(Label(text="ChildInfo Login"))
        self.username = TextInput(hint_text='Enter Username')
        self.password = TextInput(hint_text='Enter Password', password=True)
        self.add_widget(self.username)
        self.add_widget(self.password)
        
        self.child_btn = Button(text="Login as Child")
        self.child_btn.bind(on_press=self.child_login)
        self.add_widget(self.child_btn)
        
        self.parent_btn = Button(text="Login as Parent")
        self.parent_btn.bind(on_press=self.parent_login)
        self.add_widget(self.parent_btn)
    
    def child_login(self, instance):
        self.parent.clear_widgets()
        self.parent.add_widget(ChildDashboard())
    
    def parent_login(self, instance):
        self.parent.clear_widgets()
        self.parent.add_widget(ParentDashboard())

class ChildDashboard(BoxLayout):
    def _init_(self, **kwargs):
        super()._init_(orientation='vertical', **kwargs)
        self.add_widget(Label(text=f"Name: {child_info['name']}"))
        self.add_widget(Label(text=f"Age: {child_info['age']}"))
        self.add_widget(Label(text=f"Address: {child_info['address']}"))
        self.add_widget(Label(text=f"Mobile: {child_info['mobile']}"))
        self.add_widget(Label(text=f"Attendance: {child_info['attendance']}"))
        self.add_widget(Label(text=f"Overall Attendance: {child_info['overall_attendance']}"))

class ParentDashboard(BoxLayout):
    def _init_(self, **kwargs):
        super()._init_(orientation='vertical', **kwargs)
        self.add_widget(Label(text=f"Name: {child_info['name']}"))
        self.add_widget(Label(text=f"Age: {child_info['age']}"))
        self.add_widget(Label(text=f"Address: {child_info['address']}"))
        self.add_widget(Label(text=f"Mobile: {child_info['mobile']}"))
        self.add_widget(Label(text=f"Attendance: {child_info['attendance']}"))
        self.add_widget(Label(text=f"Overall Attendance: {child_info['overall_attendance']}"))
        self.add_widget(Label(text=f"Marks: {child_info['marks']}"))
        self.add_widget(Label(text=f"Total Grade: {child_info['total_grade']}"))
        self.add_widget(Label(text=f"Holidays: {child_info['holidays']}"))
        self.add_widget(Label(text=f"CGPA: {child_info['cgpa']}"))

class ChildApp(App):
    def build(self):
        return LoginScreen()

if _name_ == "_main_":
    ChildApp().run()