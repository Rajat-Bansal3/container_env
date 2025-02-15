const About = () => {
  return (
    <div className='container mx-auto p-4'>
      <h1 className='text-2xl font-bold mb-4'>About Us</h1>
      <p>This application is designed to manage server configurations.</p>
      <p>Created by Rajat Bansal</p>
      <p>
        GitHub:{" "}
        <a href='https://github.com/Rajat-Bansal3' className='text-blue-500'>
          Rajat-Bansal3
        </a>
      </p>
      <p>
        Docker:{" "}
        <a
          href='https://hub.docker.com/r/rajatbansalx86'
          className='text-blue-500'
        >
          rajatbansalx86
        </a>
      </p>
    </div>
  );
};

export default About;
