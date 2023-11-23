<?php

namespace App\Livewire;

use App\Models\User;
use Illuminate\Support\Facades\Artisan;
use Livewire\Component;

class Installer extends Component
{
    public $step = 1;

    public $name;
    public $email;
    public $password;
    public $password_confirmation;

    public function install()
    {
        $this->validate([
            'name' => 'required',
            'email' => 'required|email|unique:users,email',
            'password' => 'required|min:8|confirmed',
            'password_confirmation' => 'required|min:8',
        ]);

        $createUser = new User();
        $createUser->name = $this->name;
        $createUser->email = $this->email;
        $createUser->password = bcrypt($this->password);
        $createUser->save();

        file_put_contents(storage_path('installed'), 'installed-'.date('Y-m-d H:i:s'));

        return redirect('/admin/login');

    }

    public function render()
    {
        return view('livewire.installer');
    }
}
