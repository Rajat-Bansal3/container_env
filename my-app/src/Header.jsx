import { Link } from "react-router-dom";

const Header = () => {
  return (
    <header className='bg-gray-800 text-white p-4'>
      <nav className='flex justify-between'>
        <Link to='/' className='text-lg font-bold'>
          Home
        </Link>
        <Link to='/about' className='text-lg font-bold'>
          About Us
        </Link>
      </nav>
    </header>
  );
};

export default Header;
